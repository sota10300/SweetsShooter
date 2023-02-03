using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawnEnemy : MonoBehaviour
{
    private float chargeTime = 5.0f;

    private float timeCount;

    GameObject m_player;    //プレイヤー格納用

    [SerializeField]float m_speed;  //移動速度

    public GameObject ball; //弾格納用

    public float ballSpeed = 10.0f; //弾速

    bool isShoot;   //射撃フラグ

    Enemy m_enemyScript;

    //オーディオソース
    AudioSource m_audioSource;

    //攻撃SE
    public AudioClip m_enemyAttackSE;

/*     public enum Job //ドローン種類設定
    {
        HDrown,
        UDrown
    }

    public Job m_Job; */

    void Start()
    {
        m_player = GameObject.FindWithTag ("Sweets");

        //乱数生成
        int m_jobNum = Random.Range(0, 2);

        if(m_jobNum == 0)
        {
            StartCoroutine("HDrownMove");
        }
        else if(m_jobNum == 1)
        {
            StartCoroutine("UDrownMove");
        }

        m_audioSource = GetComponent<AudioSource>();

        m_enemyScript = GetComponent<Enemy>();
    }

    void Update()
    {
        transform.LookAt(m_player.transform);

        if(isShoot && m_enemyScript.m_hp > 0)
        {
            var shot = Instantiate(ball, transform.position, Quaternion.identity);  //弾生成
            shot.GetComponent<Rigidbody>().velocity = transform.forward.normalized * ballSpeed;
            m_audioSource.PlayOneShot(m_enemyAttackSE);
            isShoot = false;
        }
    }

    IEnumerator HDrownMove()
    {
        while(true)
        {
            for (int i=0; i<220; i++)
            {
                yield return new WaitForSeconds(0.01f);
                this.gameObject.transform.Translate (0, 0, m_speed);
            }

            yield return new WaitForSeconds(0.5f);

            isShoot = true;

            for (int i=0; i<60; i++)
            {
                yield return new WaitForSeconds(0.01f);
                this.gameObject.transform.Translate (0, 0, 0);
            }
        }
    }

        IEnumerator UDrownMove()
    {
        while(true)
        {
            for (int i=0; i<220; i++)
            {
                yield return new WaitForSeconds(0.01f);
                this.gameObject.transform.Translate (Mathf.Sin(Time.time) *0.01f, 0, m_speed);
            }

            yield return new WaitForSeconds(0.5f);

            isShoot = true;

            for (int i=0; i<60; i++)
            {
                yield return new WaitForSeconds(0.01f);
                this.gameObject.transform.Translate (0, 0, 0);
            }
        }
    }
}
