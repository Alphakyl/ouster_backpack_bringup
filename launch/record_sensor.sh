#!/bin/bash
rosbag record -o ~/kyle_repos/bagfiles/sensor_bags \
	/os1_node/points \
       	/imu_raw \
	/tf \
	/tf_static
	
