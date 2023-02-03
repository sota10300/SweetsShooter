using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class Ui : MonoBehaviour
{
    [SerializeField] TMPro.TMP_Text m_HpUi; //現在のHP数表示UI

    GameObject m_Player;    //プレイヤー格納用

    PlayerStatus m_PlayerStatusScript;  //PlayerStatusScript格納用

    float m_CurrentHp;  //現在のHP

    void Start()
    {
        m_Player = GameObject.FindWithTag("Player");

        m_PlayerStatusScript =m_Player.GetComponent<PlayerStatus>();

    }

    void Update()
    {
        m_PlayerStatusScript =m_Player.GetComponent<PlayerStatus>();

        m_CurrentHp = m_PlayerStatusScript.m_Hp;

        m_HpUi.text = m_CurrentHp.ToString();

    }
}
