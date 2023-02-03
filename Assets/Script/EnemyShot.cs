using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyShot : MonoBehaviour
{
    GameObject m_player; //プレイヤー格納用

    public GameObject ball; //弾格納用

    public float ballSpeed = 10.0f; //弾速

    void Start()
    {
        m_player = GameObject.FindWithTag ("Player");
        transform.LookAt(m_player.transform);
        StartCoroutine("BallShot");
    }

    // Update is called once per frame
    void Update()
    {
       transform.LookAt(m_player.transform);
    }

    IEnumerator BallShot()
    {
        while (true) {
        var shot = Instantiate(ball, transform.position, Quaternion.identity);
        shot.GetComponent<Rigidbody>().velocity = transform.forward.normalized * ballSpeed;
        yield return new WaitForSeconds(3.0f);
        }
    }
}
