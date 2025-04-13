# GUI Python document - Samanta
from PyQt5.QtWidgets import (
    QWidget, QSlider, QVBoxLayout, QPushButton, QApplication, QLabel, QApplication, QGridLayout, QComboBox, QInputDialog
)
from PyQt5.QtCore import Qt
from ambf_client import Client
import sys

import rospy
from std_msgs.msg import Float32
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

        # initialize slider for window size
        self.size_slider = QSlider(Qt.Horizontal)
        self.size_slider.setMinimum(10)
        self.size_slider.setMaximum(50)
        self.size_slider.setValue(38)
        self.size_slider.valueChanged.connect(self.update_size)

        # initialize slider for window disparity
        self.disparity_slider = QSlider(Qt.Horizontal)
        self.disparity_slider.setMinimum(0)
        self.disparity_slider.setMaximum(20)
        self.disparity_slider.setValue(10)
        self.disparity_slider.valueChanged.connect(self.update_disparity)

        # initialize buttons for window location
        # TODO: double check these positions in the box
        grid = QGridLayout()

        self.add_button(grid, "Bottom Right",     lambda: self.update_location(0.002, 0.75, 0.1), 1, 2)
        self.add_button(grid, "Top Right",    lambda: self.update_location(0.002, 0.75, 0.4), 0, 2)
        self.add_button(grid, "Bottom Left",  lambda: self.update_location(0.002, 0.25, 0.1), 1, 1)
        self.add_button(grid, "Top Left", lambda: self.update_location(0.002, 0.25, 0.4), 0, 1)
        
        # self.add_button(grid, "Move Left", lambda: self.update_disparity_manual(-0.01), 2, 1)
        # self.add_button(grid, "Move Right", lambda: self.update_disparity_manual(0.01), 2, 2)
        self.x_slider = QSlider(Qt.Horizontal)
        self.x_slider.setMinimum(0)
        self.x_slider.setMaximum(100)
        self.x_slider.setValue(int(self.last_location.z * 100))
        self.x_slider.valueChanged.connect(self.update_manual_location)

        self.y_slider = QSlider(Qt.Horizontal)
        self.y_slider.setMinimum(0)
        self.y_slider.setMaximum(100)
        self.y_slider.setValue(int(self.last_location.y * 100))
        self.y_slider.valueChanged.connect(self.update_manual_location)


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

        layout = QVBoxLayout()
        layout.addWidget(QLabel("Window Size"))
        layout.addWidget(self.size_slider)
        layout.addWidget(QLabel("Window Disparity"))
        layout.addWidget(self.disparity_slider)
        layout.addWidget(QLabel("Window Location"))
        layout.addWidget(QLabel("Adjust X Location (Left–Right)"))
        layout.addWidget(self.x_slider)
        layout.addWidget(QLabel("Adjust Y Location (Bottom–Top)"))
        layout.addWidget(self.y_slider)
        layout.addLayout(grid)
        layout.addWidget(self.save_button)
        layout.addWidget(self.load_button)
        layout.addWidget(QLabel("User"))
        layout.addWidget(self.user_dropdown)
        layout.addWidget(QLabel("Preset"))
        layout.addWidget(self.preset_dropdown)
        layout.addWidget(self.new_user_button)

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

    def update_location(self, disparity, x_pos, y_pos):
        msg = Point()
        msg.x = disparity
        msg.y = y_pos
        msg.z = x_pos
        self.location_pub.publish(msg)
        self.last_location = msg # to track last selection

    def update_manual_location(self):
        x_pos = self.x_slider.value() / 100.0  
        y_pos = self.y_slider.value() / 100.0  
        disparity = self.last_location.x       

        msg = Point()
        msg.x = disparity
        msg.y = y_pos
        msg.z = x_pos

        self.location_pub.publish(msg)
        self.last_location = msg  


    
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
        # TODO: need to change this so that it is dynamic!!!!
        # user_id = "user1"    
        filename = f'window_configurations.yaml'
        
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
        filename = 'window_configurations.yaml'

        if not os.path.exists(filename):
            print("No configuration file found.")
            return
        with open(filename, 'r') as f:
            # config = yaml.safe_load(f)
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



if __name__ == '__main__':
    app = QApplication(sys.argv)
    gui = SimAssistedNavGUI()
    gui.show()
    sys.exit(app.exec_())