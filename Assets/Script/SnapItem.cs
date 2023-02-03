using System.Net.NetworkInformation;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using UnityEngine.SceneManagement;

namespace Valve.VR.InteractionSystem
{
public class SnapItem : MonoBehaviour
{
    [SerializeField]string m_snapTag;   //保持可能アイテム判定用タグ名

    GameObject m_SnapObj;   //オブジェクト格納用

    [SerializeField] bool isTank;

    private bool isGrabbing;

    bool isMount = false;   //アイテム保持判定用

    void Start()
    {
        m_SnapObj = GameObject.FindWithTag("TankPoint");
    }


    void Update()
    {
        if(SceneManager.GetActiveScene().name == "Title")
        {
            Destroy(this.gameObject);
        }
    }

    private void OnAttachedToHand(Hand hand)
    {
        isGrabbing = true;
    }
      private void OnDetachedFromHand(Hand hand)
    {
        isGrabbing = false;
    }
    void OnTriggerStay(Collider other)
    {
        if(other.CompareTag(m_snapTag) && isGrabbing == false)
        {
            transform.parent = other.transform;
            transform.localRotation = Quaternion.Euler(0,0,0);
            transform.position = m_SnapObj.transform.position;
        }
        else if(isGrabbing == true)
        {
            transform.parent = null;
            SceneManager.MoveGameObjectToScene(gameObject, SceneManager.GetActiveScene());
        }
    }
}
}