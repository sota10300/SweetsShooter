using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class EnemyCount : MonoBehaviour
{
    private GameObject[] m_EnemyBox;  //エネミー格納用配列

    public bool isClear = false;    //ステージクリアフラグ

    void Start()
    {
        isClear = false;
        m_EnemyBox = GameObject.FindGameObjectsWithTag("Enemy");

    }

    void Update()
    {
        m_EnemyBox = GameObject.FindGameObjectsWithTag("Enemy");

        if(m_EnemyBox.Length <= 0)
        {
            isClear = true;
            SceneManager.LoadScene("Title");
        }
    }
}
