-- Copyright 2016 The Cartographer Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "world",
  tracking_frame = "base_link",
  published_frame = "base_link",
  odom_frame = "odom",
  provide_odom_frame = true,
  publish_frame_projected_to_2d = false,
  use_pose_extrapolator = true,
  use_odometry = false,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 0,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 1,
  lookup_transform_timeout_sec = 0.2,
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  rangefinder_sampling_ratio = 1.,
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 1.,
}

---------------------
-- DEFAULT CHANGES --
---------------------

POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 5
-- POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 10
POSE_GRAPH.constraint_builder.min_score = 0.55 --0.62
-- POSE_GRAPH.constraint_builder.min_score = 0.55
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.66

-------------------------------
-- CUSTOM MAP_BUILER CHANGES --
-------------------------------

MAP_BUILDER.use_trajectory_builder_3d = true

MAP_BUILDER.num_background_threads = 6
-- Originally set to 4

------------------------------------------
-- CUSTOM TRAJECTORY_BUILDER_3D CHANGES --
------------------------------------------

MAX_3D_RANGE = 100.
-- MAX_3D_RANGE = 60.
-- SET BASED UPON OUSTER LIMITATIONS
-- IMPACT: HAS NOT BEEN EVALUATED, NEED TO TEST EFFECT ON LATENCY AND ACCURACY

TRAJECTORY_BUILDER_3D.min_range = 1.
-- TRAJECTORY_BUILDER_3D.min_range = 0.5
-- SET BASED UPON OUSTER LIMITATIONS
-- IMPACT: HAS NOT BEEN EVALUATED, NEED TO TEST EFFECT ON LATENCY AND ACCURACY

TRAJECTORY_BUILDER_3D.num_accumulated_range_data = 1
-- TRAJECTORY_BUILDER_3D.submaps.num_range_data = 1500
-- Set to 1 because only need one Ouster point cloud message / full 360 coverage

TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.linear_search_window = 0.11
-- TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.linear_search_window = 0.15
-- IMPACT: SET BASED ON 1 M/S MAX SPEED, TRACKING ERROR IF VEHICLES GOES FASTER

TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.angular_search_window = math.rad(1.)
-- ISSUE: UNRESOLVABLE LATENCY WHEN INCREASING ABOVE 2 DEG/SEC

-- translation and rotation wegiths are really important! And sensitive...
--
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.translation_weight = 3.
-- TRAJECTORY_BUILDER_3D.ceres_scan_matcher.translation_weight = 5.

TRAJECTORY_BUILDER_3D.ceres_scan_matcher.rotation_weight = 30.
-- TRAJECTORY_BUILDER_3D.ceres_scan_matcher.rotation_weight = 4e2.

TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.num_threads = 6
-- TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.num_threads = 1

TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.hit_probability = .55
TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.miss_probability =.45

TRAJECTORY_BUILDER_3D.motion_filter.max_time_seconds = 0.5
-- TRAJECTORY_BUILDER_3D.motion_filter.max_time_seconds = 0.5
TRAJECTORY_BUILDER_3D.motion_filter.max_distance_meters= 0.1
-- TRAJECTORY_BUILDER_3D.motion_filter.max_distance_meters= 0.1
TRAJECTORY_BUILDER_3D.motion_filter.max_angle_radians = 0.4
-- TRAJECTORY_BUILDER_3D.motion_filter.max_angle_radians = 0.004

-------------------------------
-- CUSTOM POSE_GRAPH CHANGES --
-------------------------------

POSE_GRAPH.optimization_problem.huber_scale = 5e2
-- POSE_GRAPH.optimization_problem.huber_scale = 5e2

POSE_GRAPH.optimize_every_n_nodes = 45 --45 --90 --320
-- POSE_GRAPH.optimize_every_n_nodes = 90
-- Set to 320 for loop closure, set to 0 for no loop closure

POSE_GRAPH.constraint_builder.sampling_ratio = 0.3 --0.6
-- POSE_GRAPH.constraint_builder.sampling_ratio = 0.3

POSE_GRAPH.constraint_builder.max_constraint_distance = 30.
-- POSE_GRAPH.constraint_builder. max_constraint_distance = 15.

POSE_GRAPH.constraint_builder.ceres_scan_matcher.ceres_solver_options.num_threads = 6
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher.num_threads = 1
-- IMPACT: increase parameter to decrease global SLAM latency

POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_xy_search_window = 5 --10.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_xy_search_window = 5.
-- IMPACT: decrease parameter to decrease global SLAM latency

POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_z_search_window = 3 --5.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_z_search_window = 1.
-- IMPACT: decrease parameter to decrease global SLAM latency

POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.angular_search_window = math.rad(22.5)
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.angular_search_window = math.rad(15.)
-- IMPACT: MORE DRIFT-TOLERANT LOOP CLOSURES (NEED TO TRY REDUCING FOR 360 FOV CASE)
-- IMPACT: decrease parameter to decrease global SLAM latency

POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.rotation_weight = 100.
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.rotation_weight = 1.
-- IMPACT: Tried 10, caused more drift, also caused basement and 1st floor to have a bad loop closure together (when run overnight)
-- IMPACT: WEIGHTS ROTATION MORE (NEED TO TRY REDUCING FOR 360 FOV CASE)

POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.translation_weight = 10
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.translation_weight = 10

POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.only_optimize_yaw = false
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.optimize_yaw = false

POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.num_threads = 6
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.num_threads = 1
-- IMPACT: increase parameter to decrease global SLAM latency

POSE_GRAPH.optimization_problem.log_solver_summary = true
-- POSE_GRAPH.optimization_problem.log_solver_summary = false
-- SET TO TRUE SO PRINTS IMU TRANSFORM ERROR WHEN LOOP CLOSURE OCCURS

POSE_GRAPH.optimization_problem.use_online_imu_extrinsics_in_3d = false
-- POSE_GRAPH.optimization_problem.use_online_imu_extrinsics_in_3d = true
-- IMPACT: setting to false worsed performance, not sure why, may want to revisit.

POSE_GRAPH.optimization_problem.fix_z_in_3d = false
-- POSE_GRAPH.optimization_problem.fix_z_in_3d = false
-- IMPACT: Does not loop close if set to true.

POSE_GRAPH.optimization_problem.ceres_solver_options.num_threads = 6
-- POSE_GRAPH.optimization_problem.ceres_solver_options.num_threads = 7
-- IMPACT: increase parameter to decrease global SLAM latency

POSE_GRAPH.global_sampling_ratio = 0.003 --0.1
-- POSE_GRAPH.global_sampling_ratio = 0.003
-- IMPACT: decrease parameter to decrease global SLAM latency

return options
