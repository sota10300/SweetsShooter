using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Valve.VR.InteractionSystem
{
    public class ColliderChanger : MonoBehaviour
    {
        private void OnHandHoverBegin(Hand hand)
        {
            Debug.Log("OnHandHoverBegin:" + gameObject.name + "/handType:" + hand.handType);
            //if(hand.handType == SteamVR_Input_Sources.RightHand)
            //{
            //    Debug.Log("OnHandHoverBegin:RightHand");
            //}
            //else if (hand.handType == SteamVR_Input_Sources.LeftHand)
            //{
            //    Debug.Log("OnHandHoverBegin:LeftHand");
            //}
        }
        private void OnHandHoverEnd(Hand hand)
        {
            Debug.Log("OnHandHoverEnd:" + gameObject.name + "/handType:" + hand.handType);
        }

        private void OnAttachedToHand(Hand hand)
        {
            Debug.Log("OnAttachedToHand:" + gameObject.name + "/handType:" + hand.handType);
            GetComponent<Collider>().isTrigger = true;
        }

        private void OnDetachedFromHand(Hand hand)
        {
            Debug.Log("OnDetachedFromHand:" + gameObject.name + "/handType:" + hand.handType);
            GetComponent<Collider>().isTrigger = true;
        }
    }
}