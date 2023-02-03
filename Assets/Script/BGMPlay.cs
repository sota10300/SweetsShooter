using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BGMPlay : MonoBehaviour
{
    AudioSource m_audio;    //再生するためのコンポーネント

    void Start()
    {
        StartCoroutine("PlayBGM");
        m_audio = GetComponent<AudioSource>();
    }

    IEnumerator PlayBGM()
    {
        yield return new WaitForSecondsRealtime(1);
        m_audio.Play();
    }
}
