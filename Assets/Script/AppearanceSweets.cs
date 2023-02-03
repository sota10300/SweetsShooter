using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppearanceSweets : MonoBehaviour
{
    //RiftUpアニメーション中に生成するオブジェクト
    public GameObject[] m_sweets;

    //生成するオブジェクトの親
    [SerializeField] GameObject m_sweetsSpawnPoint;

    //ランダムな整数
    int m_randomNumber;

    //オブジェクトを生成
    void SweetsSpawn()
    {
        m_randomNumber = Random.Range (0, m_sweets.Length);
        Instantiate(m_sweets[m_randomNumber],m_sweetsSpawnPoint.transform);
    }

    //オブジェクトを削除
    void SweetsDelete()
    {
        GameObject m_deleteSweets;
        m_deleteSweets = m_sweetsSpawnPoint.GetComponent<Transform>().transform.GetChild(0).gameObject;
        Destroy(m_deleteSweets);
    }
}
