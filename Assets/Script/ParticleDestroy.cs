using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleDestroy : MonoBehaviour
{
    [SerializeField] float m_DestroyTime;

    void Start()
    {
        StartCoroutine("BulletDestroy");
    }

    IEnumerator BulletDestroy()
    {
        yield return new WaitForSeconds(m_DestroyTime);
        Destroy(this.gameObject);
    }
}
