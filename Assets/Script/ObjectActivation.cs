using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectActivation : MonoBehaviour
{
    [SerializeField]GameObject ActiveObject;

    void OnCollisionEnter(Collision collisionInfo)
    {
        ActiveObject.SetActive(true);
    }
}
