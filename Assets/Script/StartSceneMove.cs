using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartSceneMove : MonoBehaviour
{
    void Start()
    {
        StartCoroutine("SceneMove");
    }

    IEnumerator SceneMove()
    {
        yield return new WaitForSeconds(3.0f);
        SceneManager.LoadScene("Title");
    }
}
