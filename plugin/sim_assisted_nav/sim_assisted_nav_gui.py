# GUI Python document - Samanta
from PyQt5.QtWidgets import (
    QWidget, QSlider, QVBoxLayout, QPushButton, QApplication, QLabel, QApplication, QGridLayout, QComboBox, QInputDialog
)
from PyQt5.QtCore import Qt
from ambf_client import Client
import sys

import rospy
from std_msgs.msg import Float32, Bool
from geometry_msgs.msg import Point

import yaml
import os

class SimAssistedNavGUI(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('Sim-Assisted Navigation Control')

        # track last location choice for saving purposes
        self.last_location = Point(0.002, 0.75, 0.1)

        # ROS publishing initialization
        rospy.init_node('sim_assisted_nav_gui', anonymous=True)
        self.size_pub = rospy.Publisher('/sim_assisted_nav/small_window_size', Point, queue_size=1)
        self.location_pub = rospy.Publisher('/sim_assisted_nav/window_location', Point, queue_size=1)
        self.disparity_pub = rospy.Publisher('/sim_assisted_nav/small_window_disparity', Float32, queue_size=1)
        self.toggle_pub = rospy.Publisher('/sim_assisted_nav/toggle_sim_microscope', Bool, queue_size=1)
        self.blending_pub = rospy.Publisher('/sim_assisted_nav/blending_ratio', Float32, queue_size=1)

        # adding button for changing view of microscope or simulation
        # self.view_toggle_pub = rospy.Publisher('/sim_assisted_nav/view_toggle', Bool, queue_size=1)
        self.use_microscope = False
        self.toggle_view_button = QPushButton("Toggle View (Sim/Microscope)")
        self.toggle_view_button.clicked.connect(self.toggle_view)       

        # initialize slider for window size
        self.size_slider = QSlider(Qt.Horizontal)
        self.size_slider.setMinimum(10)
        self.size_slider.setMaximum(50)
        self.size_slider.setValue(38)
        self.size_slider.valueChanged.connect(self.update_size)

        # initialize slider for window disparity
        self.disparity_slider = QSlider(Qt.Horizontal)
        self.disparity_slider.setMinimum(0)
        self.disparity_slider.setMaximum(50)
        self.disparity_slider.setValue(10)
        self.disparity_slider.valueChanged.connect(self.update_disparity)

        # initialize slider for y movement
        self.y_slider = QSlider(Qt.Horizontal)
        self.y_slider.setMinimum(0)
        self.y_slider.setMaximum(100)
        self.y_slider.setValue(int(self.last_location.y * 100))
        self.y_slider.valueChanged.connect(self.update_manual_location)

        # initialize slider for blending ratio
        self.blending_slider = QSlider(Qt.Horizontal)
        self.blending_slider.setMinimum(0)
        self.blending_slider.setMaximum(100)
        self.blending_slider.setValue(30)
        self.blending_slider.valueChanged.connect(self.update_blending_ratio)


        # save and load configuration buttons
        self.save_button = QPushButton("Save Config")
        self.save_button.clicked.connect(self.save_config)
        self.load_button = QPushButton("Load Config")
        self.load_button.clicked.connect(self.load_config)

        # dynamic user configuration options
        self.user_dropdown = QComboBox()
        self.preset_dropdown = QComboBox()
        self.refresh_presets()
        self.user_dropdown.currentTextChanged.connect(self.refresh_presets)
        self.new_user_button = QPushButton("Add New User")
        self.new_user_button.clicked.connect(self.add_new_user)

        # add filepath options
        self.saved_paths = []
        self.path_dropdown = QComboBox()
        self.new_file_path = QPushButton("Add New File Path")
        self.new_file_path.clicked.connect(self.add_new_file_path)

        # remember last used path
        self.config_file = 'gui_config.yaml'
        self.default_path = self.load_default_path()

        if self.default_path:
            self.path_dropdown.addItem(self.default_path)
            self.path_dropdown.setCurrentText(self.default_path)

        layout = QVBoxLayout()
        layout.addWidget(QLabel("Switch Main View (Simulation/ Microscope)"))
        layout.addWidget(self.toggle_view_button)
        layout.addWidget(QLabel("Window Size"))
        layout.addWidget(self.size_slider)
        layout.addWidget(QLabel("Window Disparity"))
        layout.addWidget(self.disparity_slider)
        layout.addWidget(QLabel("Adjust Y Location (Bottom–Top)"))
        layout.addWidget(self.y_slider)
        layout.addWidget(QLabel("Blending Ratio"))
        layout.addWidget(self.blending_slider)
        layout.addWidget(self.save_button)
        layout.addWidget(self.load_button)
        layout.addWidget(QLabel("User"))
        layout.addWidget(self.user_dropdown)
        layout.addWidget(QLabel("Preset"))
        layout.addWidget(self.preset_dropdown)
        layout.addWidget(self.new_user_button)
        layout.addWidget(QLabel("Add FilePath"))
        layout.addWidget(self.path_dropdown)
        layout.addWidget(self.new_file_path)

        self.setLayout(layout)

    def add_button(self, layout, name, callback, row=0, col=0):
        btn = QPushButton(name)
        btn.clicked.connect(callback)
        layout.addWidget(btn, row, col)

    def update_size(self, value):
        height = value / 100.0
        msg = Point()
        msg.x = min(max(height, 0.1), 0.5)
        self.size_pub.publish(msg)

    def update_location(self, y_pos):
        msg = Point()
        # msg.x = disparity
        msg.y = y_pos
        # msg.z = x_pos
        self.location_pub.publish(msg)
        self.last_location = msg # to track last selection

    def update_manual_location(self):
        # x_pos = self.x_slider.value() / 100.0  
        y_pos = self.y_slider.value() / 100.0  
        disparity = self.disparity_slider.value() / 100.0      

        msg = Point()
        msg.x = disparity
        msg.y = y_pos
        # msg.z = x_pos

        self.location_pub.publish(msg)
        self.last_location = msg  

    def update_blending_ratio(self, value):
        blending = value / 100.0
        self.blending_pub.publish(Float32(data=blending))
    
    def update_disparity(self, value):
        disparity = value / 100.0
        self.disparity_pub.publish(Float32(data=disparity))

    def update_disparity_manual(self, delta):
        current = self.disparity_slider.value() / 100.0
        new_val = min(max(current + delta, 0.0), 0.5)  
        self.disparity_slider.setValue(int(new_val * 100)) 

    def save_config(self):
        user_id = self.user_dropdown.currentText()
        preset_name, ok = QInputDialog.getText(self, "Preset Name", "Enter preset name: ")

        if not ok or not preset_name:
            return

        config = {
            'size_slider': self.size_slider.value(),
            'disparity_slider': self.disparity_slider.value(), 
            'location': {
                'x': self.last_location.x,
                'y': self.last_location.y,
                'z': self.last_location.z,
            }   
        }
        selected_path = self.path_dropdown.currentText()
        if not selected_path:
            print("No file path selected!")
            return

        filename = os.path.join(selected_path, 'window_configurations.yaml')
        
        if os.path.exists(filename):
            with open(filename, 'r') as f:
                all_configs = yaml.safe_load(f) or {}
        else:
            all_configs = {}

        if user_id not in all_configs:
            all_configs[user_id] = {}
        all_configs[user_id][preset_name] = config

        with open(filename, 'w') as f:
            yaml.dump(all_configs, f)

        self.refresh_presets()
    
        print(f"Saved configuration for {user_id}-{preset_name}")
    
    def load_config(self):
        user_id = self.user_dropdown.currentText()
        preset = self.preset_dropdown.currentText()
        path = self.path_dropdown.currentText()

        if not path:
            print("No file path selected!")
            return
        
        filename = os.path.join(selected_path, 'window_configurations.yaml')

        if not os.path.exists(filename):
            print("No configuration file found.")
            return

        with open(filename, 'r') as f:
            all_configs = yaml.safe_load(f) or {}

        config = all_configs.get(user_id, {}).get(preset)

        if not config:
            print("Preset not found.")
            return

        self.size_slider.setValue(config['size_slider'])
        self.disparity_slider.setValue(config['disparity_slider'])

        loc = config['location']
        self.update_location(loc['x'], loc['z'], loc['y'])
        self.x_slider.setValue(int(loc['z'] * 100))
        self.y_slider.setValue(int(loc['y'] * 100))

        print(f"Loaded configuration for {user_id}-{preset}.")

    def refresh_presets(self):
        filename = 'window_configurations.yaml'

        if not os.path.exists(filename):
            self.user_dropdown.clear()
            self.preset_dropdown.clear()
            self.user_dropdown.addItem("user1") # this is just set to a default user rn
            return

        with open(filename, 'r') as f:
            all_configs = yaml.safe_load(f) or {}

        current_user = self.user_dropdown.currentText()
        self.user_dropdown.blockSignals(True)
        self.user_dropdown.clear()
        user_list = list(all_configs.keys())
        if not user_list:
            user_list = ["user1"]
            all_configs[user1] = {}
        self.user_dropdown.addItems(user_list)
        self.user_dropdown.blockSignals(False)

        if current_user in user_list:
            if self.user_dropdown.currentText() != current_user:
                self.user_dropdown.blockSignals(True)
                self.user_dropdown.setCurrentText(current_user)
                self.user_dropdown.blockSignals(False)
        else:
            self.user_dropdown.blockSignals(True)
            self.user_dropdown.setCurrentIndex(0)
            self.user_dropdown.blockSignals(False)
            current_user = self.user_dropdown.currentText()
            
        # self.user_dropdown.setCurrentText(user)
        self.preset_dropdown.clear()
        presets = list(all_configs.get(current_user, {}).keys())
        if presets:
            self.preset_dropdown.addItems(presets)

    def add_new_user(self):
        new_user, ok = QInputDialog.getText(self, "New User", "Enter new user ID:")
        if not ok or not new_user.strip():
            return

        filename = 'window_configurations.yaml'
        if os.path.exists(filename):
            with open(filename, 'r') as f:
                all_configs = yaml.safe_load(f) or {}
        else:
            all_configs = {}

        if new_user in all_configs:
            print("User already exists.")
        else:
            all_configs[new_user] = {}
            with open(filename, 'w') as f:
                yaml.dump(all_configs, f)
            print(f"Added new user: {new_user}")

        self.refresh_presets()
        self.user_dropdown.setCurrentText(new_user)
    
    def toggle_view(self):
        self.use_microscope = not self.use_microscope # switch the bool value
        self.toggle_pub.publish(Bool(data=self.use_microscope))

    def add_new_file_path(self):
        new_path, ok = QInputDialog.getText(self, "New File Path", "Enter new file path:")
        if not ok or not new_path.strip():
            return

        if not os.path.exists(new_path):
            print("Invalid file path entered!")
            return
        
        if new_path not in self.saved_paths:
            self.saved_paths.append(new_path)
            self.path_dropdown.addItem(new_path)

        self.path_dropdown.setCurrentText(new_path)
        self.save_default_path(new_path)

    def load_default_path(self):
        if os.path.exists(self.config_file):
            with open(self.config_file, 'r') as f:
                config = yaml.safe_load(f)
                return config.get('last_path', '')
        return

    def save_default_path(self, path):
        with open(self.config_file, 'w') as f:
            yaml.dump({'last_path': path}, f)



if __name__ == '__main__':
    app = QApplication(sys.argv)
    gui = SimAssistedNavGUI()
    gui.show()
    sys.exit(app.exec_())