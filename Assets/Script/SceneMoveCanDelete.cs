using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneMoveCanDelete : MonoBehaviour
{
    bool isDestroy;

    void Update()
    {
        if(SceneManager.GetActiveScene().name == "Title" && !isDestroy)
        {
            GameObject m_Child = transform.GetChild(0).gameObject;
            Destroy(m_Child);
            isDestroy = true;
        }
        else
        {
            isDestroy = false;
        }
    }
}
