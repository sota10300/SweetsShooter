using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    //最大HP
    [SerializeField] float m_maxHp;

    //現在HP
    public float m_hp;

    //SE再生フラグ
    bool isPlaySE = false;

    //お菓子の山オブジェクト
    GameObject m_sweetsMountain;

    //お菓子の山スクリプト
    SweetsMountain m_sweetsMountainScript;

    //メッシュ
    public SkinnedMeshRenderer m_meshRenderer;

    //爆発エフェクト
    public GameObject m_defeatExplosion;

    AudioSource m_audioSource;

    public AudioClip m_defeatSE;

    public AudioClip m_bulletHitSE;

    public AudioClip m_enemySpawnSE;

    private void Start()
    {
        m_hp = m_maxHp;

        m_audioSource = GetComponent<AudioSource>();
        m_audioSource.PlayOneShot(m_enemySpawnSE);

        m_sweetsMountain = GameObject.FindWithTag("Sweets");
        m_sweetsMountainScript = m_sweetsMountain.GetComponent<SweetsMountain>();
    }

    void Update()
    {
        if(m_hp <= 0)
        {
            //オブジェクトが削除されるとonTriggerExitが反応しないためオブジェクトの位置変更
            //transform.position = new Vector3(100,100,100);

            //メッシュを非表示
            m_meshRenderer.enabled = false;

            //影を削除
            Destroy(gameObject.transform.Find("Shadow").gameObject);

            StartCoroutine("TestDestroy");
        }

        if(m_sweetsMountainScript.m_remainingQuantity <= 0)
        {
            //オブジェクトが削除されるとonTriggerExitが反応しないためオブジェクトの位置変更
            //transform.position = new Vector3(100,100,100);

            //メッシュを非表示
            m_meshRenderer.enabled = false;

            //影を削除
            Destroy(gameObject.transform.Find("Shadow").gameObject);

            StartCoroutine("TestDestroy");
        }
    }

    public void Damage(float attackPower)
    {
        m_hp = m_hp - attackPower;  //HP減少

        m_audioSource.PlayOneShot(m_bulletHitSE);
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.gameObject == m_sweetsMountain)
        {
            m_hp = 0;

/*             //オブジェクトが削除されるとonTriggerExitが反応しないためオブジェクトの位置変更
            transform.position = new Vector3(100,100,100);
            StartCoroutine("TestDestroy"); */
        }
    }

    IEnumerator TestDestroy()
    {
        if(!isPlaySE)
        {
            //SE再生
            m_audioSource.PlayOneShot(m_defeatSE);
            Instantiate(m_defeatExplosion,this.gameObject.transform);
        }

        isPlaySE = true;

        //コライダー無効化、オブジェクト削除だとOnTriggerExitが反応しないので位置を移動
        transform.position = new Vector3(100,100,100);

        yield return new WaitForSecondsRealtime(2);

        Destroy(this.gameObject);
    }
}
