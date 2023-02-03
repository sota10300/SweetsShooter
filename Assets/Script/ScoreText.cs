using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class ScoreText : MonoBehaviour
{
    private TextMeshProUGUI m_scoreTextMesh;    //スコアを表示するTextMesh

    GameObject m_scoreObject;   //スコアオブジェクト

    Score m_scoreScript;    //スコアスクリプト

    void Start()
    {
        m_scoreObject = GameObject.Find("Score");   //スコアオブジェクト検索

        m_scoreScript = m_scoreObject.GetComponent<Score>();    //スコアスクリプト取得

        m_scoreTextMesh = this.GetComponent<TextMeshProUGUI>(); //テキストメッシュ取得

        m_scoreTextMesh.text = m_scoreScript.m_score.ToString();    //スコア表示
    }

}
