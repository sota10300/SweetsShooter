using System.Text;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.SceneManagement;

public class CountDownTimer : MonoBehaviour
{
    [SerializeField]int m_minutesInitialValue;  //分

    int m_minutes;

    float m_second; //秒

    [SerializeField]TextMeshProUGUI m_textMeshTimer; //タイマー表示テキストメッシュ

    [SerializeField]PlayerStatus m_lifeObject; //ライフオブジェクト
    [SerializeField]TextMeshProUGUI m_textMeshLife; //ライフ表示テキストメッシュ

    public bool isGameEnd; //ゲーム終了フラグ

    void Start()
    {
        m_second = 0;
        m_minutes = m_minutesInitialValue;
        isGameEnd = false;
    }

    void Update()
    {
        Timer();

        Life();

        if(SceneManager.GetActiveScene().name == "Title")
        {
            isGameEnd = false;
            m_minutes = m_minutesInitialValue;
            m_second = 0;
        }

        m_textMeshTimer.text = m_minutes.ToString() + ":" + m_second.ToString("F0");
    }

    void Timer()
    {
        if(SceneManager.GetActiveScene().name == "Stage1")
        {
            if(!isGameEnd)
            {
                m_second -= Time.deltaTime; //フレームごとにフレーム秒数を引く
            }

            if(m_second <= 0 && m_minutes > 0)
            {
                m_minutes--;
                m_second = 60;
            }
            else if(m_second <= 0 && m_minutes <= 0)
            {
                isGameEnd = true;
            }
        }
    }

    void Life()
    {
        m_textMeshLife.text = m_lifeObject.m_Hp.ToString();
        if(m_lifeObject.m_Hp <= 0)
        {
            isGameEnd = true;
        }
    }
}
