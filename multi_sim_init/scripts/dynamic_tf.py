#!/usr/bin/env python3
import rospy
import tf2_ros
import tf_conversions
from geometry_msgs.msg import PoseStamped, TransformStamped

class Dynamic_tf_broadcaster:
    def __init__(self):
        robot_name = '/' + rospy.get_param("~agent_name")
        self.frame_name = robot_name + '/base_link'
        self.subscriber = rospy.Subscriber(robot_name+'/pose', PoseStamped, self.pose_callback)
        self.broadcaster = tf2_ros.TransformBroadcaster()
        
        
    def pose_callback(self, pose_stamped):
        """
        Callback function that receives pose updates and broadcasts them.
        """
        transform = TransformStamped()
        # Set the header information on the transform
        transform.header.stamp = pose_stamped.header.stamp
        transform.header.frame_id = 'world'
        transform.child_frame_id = self.frame_name

        # Set the pose information on the transform
        transform.transform.translation.x = pose_stamped.pose.position.x
        transform.transform.translation.y = pose_stamped.pose.position.y
        transform.transform.translation.z = pose_stamped.pose.position.z
        transform.transform.rotation.x = pose_stamped.pose.orientation.x
        transform.transform.rotation.y = pose_stamped.pose.orientation.y
        transform.transform.rotation.z = pose_stamped.pose.orientation.z
        transform.transform.rotation.w = pose_stamped.pose.orientation.w

        # Broadcast the transform
        self.broadcaster.sendTransform(transform)

if __name__ == '__main__':
    
    
    rospy.init_node('dynamic_tf_broadcaster', anonymous=True)
    broadcaster_obj = Dynamic_tf_broadcaster()
    try:
        rospy.spin()
    except KeyboardInterrupt:
        print("TF broadcaster shutting down!")

