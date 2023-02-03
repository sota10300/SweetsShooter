using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Result : MonoBehaviour
{

    //public GameObject m_sweets;

    //スコア計算スクリプトが付いたオブジェクト
    GameObject m_scoreObject;

    //スコア計算スクリプト
    Score m_scoreScript;

    //トロフィー
    GameObject m_Trophy;

    bool isTrophyDown;

    [SerializeField] int[] m_clearRankPoint = new int[1];

    [SerializeField]float m_trophyDropTime = 5f;

    public GameObject m_returnButton;

    //デバッグ用
    [SerializeField] bool isTest;

    public GameObject m_sweetsMountain;

    SweetsMountain m_sweetsMountainScript;

    AudioSource m_audioSource;
    public AudioClip m_clearSE;

    void Start()
    {
        m_scoreObject = GameObject.Find("Score");

        m_scoreScript = m_scoreObject.GetComponent<Score>();

        m_audioSource = GetComponent<AudioSource>();

        isTrophyDown = true;

        m_sweetsMountainScript = m_sweetsMountain.GetComponent<SweetsMountain>();
    }

    void Update()
    {
        Debug.Log(m_Trophy);

        if(m_scoreScript.m_score >= m_clearRankPoint[0]) //ケーキ条件
        {
            m_Trophy = (GameObject)Resources.Load("CakeTrophy");
        }
        else if (m_scoreScript.m_score < m_clearRankPoint[0] && m_scoreScript.m_score >= m_clearRankPoint[1])   //ジンジャーブレッド条件
        {
            m_Trophy = (GameObject)Resources.Load("GingerbreadTrophy");
        }
        else if (m_scoreScript.m_score < m_clearRankPoint[1])   //ロリポップ条件
        {
            m_Trophy = (GameObject)Resources.Load("LollipopTrophy");
        }

        if(m_sweetsMountainScript.m_remainingQuantity <= 0 && isTrophyDown)
        {
            StartCoroutine("TrophyDrop");
            isTrophyDown = false;
        }

        if(isTest && isTrophyDown)
        {
            StartCoroutine("TrophyDrop");
            isTrophyDown = false;
        }

    }

    IEnumerator TrophyDrop()
    {
        yield return new WaitForSecondsRealtime(m_trophyDropTime);
        m_audioSource.PlayOneShot(m_clearSE);
        Instantiate (m_Trophy,this.gameObject.transform);
        yield return new WaitForSecondsRealtime(6f);
        m_returnButton.SetActive(true);
    }
}
