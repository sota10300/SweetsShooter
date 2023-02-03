using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerStatus : MonoBehaviour
{
    [SerializeField] public float m_MaxHp; //最大HP

    public float m_Hp; //現在HP

    private void Start()
    {
        m_Hp = m_MaxHp;
    }

    void Update()
    {
        if(m_Hp <= 0 && SceneManager.GetActiveScene().name == "Title")
        {
            m_Hp = m_MaxHp;
        }
    }

    //エネミーへのダメージ処理
    public void Damage(float attackPower)
    {
        if(m_Hp > 0)
        {
            m_Hp = m_Hp - attackPower;  //HP減少
        }
    }

    //プレイヤーのHP減少処理（仕様変更のため仮削除）
/*     void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Enemy") && m_Hp > 0)
        {
            m_Hp = m_Hp - 1;
        }

        if(other.CompareTag("EnemyBullet") && m_Hp > 0)
        {
            m_Hp = m_Hp - 1;
        }
    } */
}
