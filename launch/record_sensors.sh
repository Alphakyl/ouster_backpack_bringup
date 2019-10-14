#!/bin/bash
rosbag record -o /media/ohrad/8b9bc8cc-/ouster_rig_data/ \
	/points_raw_1 \
	/points_raw_2 \
  /imu_raw \
	/tf \
	/tf_static \
	/lidar0/scan\
	/lidar1/scan\
	
