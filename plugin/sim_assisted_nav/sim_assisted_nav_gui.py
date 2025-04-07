# GUI Python document - Samanta
from PyQt5.QtWidgets import (
    QWidget, QSlider, QVBoxLayout, QPushButton, QApplication, QLabel, QApplication, QGridLayout
)
from PyQt5.QtCore import Qt
from ambf_client import Client
import sys

import rospy
from std_msgs.msg import Float32
from geometry_msgs.msg import Point

class SimAssistedNavGUI(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('Sim-Assisted Navigation Control')

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


        layout = QVBoxLayout()
        layout.addWidget(QLabel("Window Size"))
        layout.addWidget(self.size_slider)
        layout.addWidget(QLabel("Window Disparity"))
        layout.addWidget(self.disparity_slider)
        layout.addWidget(QLabel("Window Location"))
        layout.addLayout(grid)
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

    
    def update_disparity(self, value):
        disparity = value / 100.0
        self.disparity_pub.publish(Float32(data=disparity))

    def update_disparity_manual(self, delta):
        current = self.disparity_slider.value() / 100.0
        new_val = min(max(current + delta, 0.0), 0.5)  
        self.disparity_slider.setValue(int(new_val * 100)) 


if __name__ == '__main__':
    app = QApplication(sys.argv)
    gui = SimAssistedNavGUI()
    gui.show()
    sys.exit(app.exec_())