using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlowMotion : MonoBehaviour
{
    [SerializeField]float m_slowSpeed;
    [SerializeField]int m_slowTime;
    string m_tag;
    bool isStay;
    bool isEnter;
    bool isSlow;
    [SerializeField]bool isDestroy;

    // Start is called before the first frame update
    void Start()
    {
        Time.timeScale = 1.0f;
        GetComponent<Renderer>().material.color = Color.blue;
    }

    // Update is called once per frame
    void Update()
    {
/*         if(isStay && isEnter){
        StartCoroutine(EndSlow());} */

/*         if(Input.GetKey(KeyCode.X)){
            EndSlow();
            } */
    }

    void BeginSlow()
    {
        // 速度を遅くする（10%）
        Time.timeScale = m_slowSpeed;
    }

    IEnumerator EndSlow(){
        GetComponent<Renderer>().material.color = Color.red;
        // 速度を遅くする
        Time.timeScale = m_slowSpeed;
        yield return new WaitForSecondsRealtime(m_slowTime);
        GetComponent<Renderer>().material.color = Color.blue;
        // 速度を通常に戻す
        Time.timeScale = 1.0f;
        if(isDestroy){Destroy(gameObject);}
        else if(!isDestroy){isSlow = false;}
    }

    void OnTriggerStay(Collider other)
    {
        if(other.CompareTag("Slot1")){
            isStay = true;
        }
    }
    void OnTriggerExit(Collider other)
    {
        if(other.CompareTag("Slot1")){
            isStay = false;
        }
    }

    void OnTriggerEnter(Collider other2)
    {
        if(other2.CompareTag("touchPoint") && isStay == true && isSlow == false){
        isSlow = true;
            StartCoroutine(EndSlow());
        }
    }
}
