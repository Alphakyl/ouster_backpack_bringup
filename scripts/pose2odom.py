#!/usr/bin/env python
import rospy
import tf

from nav_msgs.msg import Odometry
from geometry_msgs.msg import Pose

class ODOM:
	def __init__(self):
		self.world_frame_id = "world"
		self.base_frame_id = "base_link"
		self.vantage_frame_id = "vantage_2"


#		self.sub = rospy.Subscriber('/vrpn_client_node/vantage/pose', PoseStamped, self.listen)
		self.pub = rospy.Publisher('/vantage_odom', Odometry, queue_size=100)
		self.tf_listener = tf.TransformListener()

	def listen(self):
		try:
			self.tf_listener.waitForTransform(self.world_frame_id, self.vantage_frame_id, rospy.Time.now(), rospy.Duration(1))
			(bundle_pose, bundle_rot) = self.tf_listener.lookupTransform(self.world_frame_id, self.vantage_frame_id, rospy.Time(0))
			rospy.loginfo("TF Recieved")
		except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException, tf.Exception) as e:
			rospy.logwarn("TF Exception")
			return

		pose_msg=Pose()
		pose_msg.position.x=bundle_pose[0]
		pose_msg.position.y=bundle_pose[1]
		pose_msg.position.z=bundle_pose[2]
		pose_msg.orientation.x=bundle_rot[0]
		pose_msg.orientation.y=bundle_rot[1]
		pose_msg.orientation.z=bundle_rot[2]
		pose_msg.orientation.w=bundle_rot[3]
		odom=Odometry()
		odom.header.stamp = rospy.get_rostime()
		odom.header.frame_id = self.world_frame_id
		odom.pose.pose = pose_msg
		rospy.loginfo("TF Publishing")
		self.pub.publish(odom)

def main():
	rospy.init_node('pose2odom')
	listen=ODOM()
	while not rospy.is_shutdown():
		listen.listen()
	rospy.spin()

if __name__ == '__main__':
  main()
