#!/bin/bash
rosbag record -o /media/ohrad/833ba77b-5f28-4ce1-a448-90ef385011c2/ouster_rig_data/ \
	/points_raw_1 \
	/points_raw_2 \
  /imu_raw \
	/tf \
	/tf_static \
	/lidar0/scan\
	/lidar1/scan\
	
