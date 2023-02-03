using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Tank : MonoBehaviour
{
    int m_ObjCount; //シーンにあるオブジェクト数

    private bool isGrabbing;    //掴みフラグ

    EnemyCount m_EnemyCount;  //スクリプト格納用

    GameObject m_EnemyCounter;    //オブジェクト格納用

    void Start()
    {
        m_EnemyCounter = GameObject.FindWithTag("EnemyCount");
    }
    void Update()
    {

        m_EnemyCount = m_EnemyCounter.GetComponent<EnemyCount>();

        if(m_EnemyCount.isClear == true)
        {
            Destroy(this.gameObject);
        }
    }
}
