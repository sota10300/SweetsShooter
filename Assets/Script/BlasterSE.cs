using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;

namespace Valve.VR.InteractionSystem
{
public class BlasterSE : MonoBehaviour
{
    public AudioSource m_audioSource;
    public AudioClip[] m_shootSE;

    void Start()
    {
        m_audioSource = GetComponent<AudioSource>();
    }
}
}
