using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Beam : MonoBehaviour
{
    [SerializeField] int m_beamTime;    //ビーム照射時間
    void Start()
    {
        StartCoroutine(BeamDestroy());
    }

    IEnumerator BeamDestroy()
    {
        yield return new WaitForSecondsRealtime(m_beamTime);
        Destroy(this.gameObject);
    }
}
