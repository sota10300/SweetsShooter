using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SweetsMountain : MonoBehaviour
{
    //お菓子最大数
    public int m_remainingQuantity = 100;

    //お菓子大サイズオブジェクト
    public GameObject m_maxModel;

    //お菓子中サイズオブジェクト
    public GameObject m_middleModel;

    //お菓子小サイズオブジェクト
    public GameObject m_minModel;

    //中サイズ表示しきい値
    int m_middleValue;

    //小サイズ表示しきい値
    int m_minValue;

    //お菓子の残り数が0になったとき削除するオブジェクト
    [Header("お菓子の残り数が0になったとき削除するオブジェクト")]
    public GameObject[] m_destroyObject;

    void Start()
    {
        //しきい値の60％と20％を計算
        m_middleValue = m_remainingQuantity * 60 /100;
        m_minValue = m_remainingQuantity * 20 / 100;
    }
    void Update()
    {
        if(m_remainingQuantity <= m_middleValue && m_remainingQuantity > m_minValue)
        {
            Destroy(m_maxModel);
            m_middleModel.SetActive(true);
        }
        else if (m_remainingQuantity <= m_minValue && m_remainingQuantity > 0)
        {
            Destroy(m_middleModel);
            m_minModel.SetActive(true);
        }
        else if (m_remainingQuantity <= 0)
        {
            Destroy(m_minModel);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        //敵もしくは敵の攻撃ヒット時におかしの数-1
        if(other.CompareTag("EnemyBullet") || other.CompareTag("Enemy"))
        {
            m_remainingQuantity--;
        }

        //お菓子の数が０になったら非表示
        if(m_remainingQuantity <= 0)
        {
            for(int i = 0; i < m_destroyObject.Length;i++)
            {
                Destroy(m_destroyObject[i]);
            }
            this.gameObject.SetActive(false);
        }
    }
}
