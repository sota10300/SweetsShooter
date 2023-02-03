using System.Net.Mime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace Valve.VR.InteractionSystem
{
public class Button : MonoBehaviour
{
    [SerializeField] string m_sceneName;    //移動先のシーン名

    public bool is_touch;  //接触フラグ

    float m_scene;

    bool isShoot;

    //タイトルSEが複数回ならないようためのトリガー
    bool isSceneTrigger;

    Shoot shoot;

    //オーディオソース
    AudioSource m_audioSource;

    //ゲームスタートSE
    public AudioClip m_gameStartSE;

    //trueの場合ゲーム終了ボタンになる
    [SerializeField]bool isGameEndButton;

    void Start()
    {
        is_touch = false;

        m_scene = 0;

        m_audioSource = GetComponent<AudioSource>();

        isSceneTrigger = true;
    }

    void FixedUpdate()
    {
        if(is_touch && isSceneTrigger && !isGameEndButton)
        {
            StartCoroutine("SceneMove");
        }
        else if(is_touch && isSceneTrigger && isGameEndButton)
        {
            EndGame();
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("leftHand"))
        {
            is_touch = true;
            this.GetComponent<Renderer> ().material.color = new Color(Random.value, Random.value, Random.value, 1.0f);
        }
    }

    IEnumerator SceneMove()
    {
        isSceneTrigger = false;
        m_audioSource.PlayOneShot(m_gameStartSE);
        yield return new WaitForSeconds(0.7f);
        SceneManager.LoadScene(m_sceneName);
    }

    public void EndGame()
    {
        #if UNITY_EDITOR
            UnityEditor.EditorApplication.isPlaying = false;//ゲームプレイ終了
        #else
            Application.Quit();//ゲームプレイ終了
        #endif
    }
}
}
