using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneStart : MonoBehaviour
{
    private GameObject[] m_ParticleBox;

    private void Update()
    {
        if(SceneManager.GetActiveScene().name == "Title")
        {
            m_ParticleBox = GameObject.FindGameObjectsWithTag("PlayerBullet");
        }
        else
        {
            foreach (GameObject m_PlayerBullet in m_ParticleBox)
            {
                Destroy(m_PlayerBullet);
            }
        }
    }

}
