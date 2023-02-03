using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NPCSpawn : MonoBehaviour
{
    [SerializeField] GameObject m_npc;

    void Start()
    {
        StartCoroutine("Spawn");
    }

    IEnumerator Spawn()
    {
        Instantiate(m_npc);

        yield return new WaitForSecondsRealtime(15f);

        Instantiate(m_npc);

        yield return new WaitForSecondsRealtime(15f);

        Instantiate(m_npc);

        Destroy(this.gameObject);
    }
}
