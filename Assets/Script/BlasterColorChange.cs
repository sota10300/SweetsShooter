using System.Net.NetworkInformation;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;

namespace Valve.VR.InteractionSystem
{
public class BlasterColorChange : MonoBehaviour
{
    GameObject m_Bullet;    //Bulletオブジェクト格納用

    Shoot m_Shoot;  //Shootスクリプト

    [SerializeField] Material[] m_Material; //タイプごとのマテリアル

    [SerializeField] MeshRenderer m_MeshRenderer; //メッシュ

    [SerializeField] AudioClip[] m_collarChangeSE;  //ブラスターのSE

    void Start()
    {
        m_Bullet = GameObject.Find("bullet");
        m_Shoot = m_Bullet.GetComponent<Shoot>();
    }


    void Update()
    {
        //switch文
        switch(m_Shoot.m_Num){
            //条件1
            case 0:
                //処理1
                m_MeshRenderer.material = m_Material[0];
                //break文
                break;

                //条件2
            case 1:
                //処理2
                m_MeshRenderer.material = m_Material[1];
                //break文
                break;

                //条件2
            case 2:
                //処理2
                m_MeshRenderer.material = m_Material[2];
                //break文
                break;

            //デフォルト処理
            default:
                //処理Default
                m_MeshRenderer.material = m_Material[3];
                //break文
                break;
        }
    }
}
}
