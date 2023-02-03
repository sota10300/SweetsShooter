using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyBullet : MonoBehaviour
{
    [SerializeField] float m_AttackPower; //攻撃力

    private void Start()
    {
        StartCoroutine("DestroyBullet");
    }

    void OnTriggerEnter(Collider other)
    {
        if(CompareTag("Player") || CompareTag("Floor"))
        {
            other.GetComponent<PlayerStatus>().Damage(m_AttackPower);
            Destroy(this.gameObject);
        }
    }

    IEnumerator DestroyBullet()
    {
        yield return new WaitForSeconds(15.0f);
        Destroy(this.gameObject);
    }
}
