#!/bin/bash
rosbag record -o ~/kyle_repos/bagfiles/ \
	/constraint_list \
	/husky_odom \
	/husky_point \
	/imu_raw \
	/joint_states \
	/landmark_poses_list \
	/map \
	/os1_node/imu \
	/os1_node/imu_packets \
	/os1_node/lidar_packets \
	/os1_node/points \
	/passthrough/output \
	/passthrough/parameter_descriptions \
	/passthrough/parameter_updates \
	/pcl_manager/bond \
	/rosout \
	/rousout_agg \
	/scan_matched_points2 \
	/submap_list \
	/tf \
	/tf_static \
	/trajectory_node_list

	
