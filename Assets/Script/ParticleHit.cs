using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ParticleHit : MonoBehaviour
{
    [SerializeField] float attackPower; //攻撃力

  private void Start()
  {
    SceneManager.MoveGameObjectToScene(gameObject, SceneManager.GetActiveScene());
  }

    void OnParticleCollision(GameObject obj)
  {
		obj.GetComponent<Enemy>().Damage(attackPower);
	}
}
