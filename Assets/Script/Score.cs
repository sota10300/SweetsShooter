using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Score : MonoBehaviour
{
    public int m_score;

    public AudioClip m_scoreUpSE;
    public AudioSource m_audioSource;
    void Start()
    {
        m_score = 0;
        m_audioSource = GetComponent<AudioSource>();
    }
}
