using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemSlot : MonoBehaviour
{
    int m_ObjCount; //オブジェクト数
    Collider m_Collider;    //コライダー格納

    void Start()
    {
        m_Collider = GetComponent<Collider>();
    }

    void Update()
    {
        m_ObjCount = this.transform.childCount;
        if(m_ObjCount == 0){
            m_Collider.enabled = true;
        }else if(m_ObjCount >= 1){
            m_Collider.enabled = false;
        }
    }
}
