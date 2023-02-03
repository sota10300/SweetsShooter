using System.Net.NetworkInformation;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;
using UnityEngine.SceneManagement;

namespace Valve.VR.InteractionSystem
{

    public class CanTypeIdentification : MonoBehaviour
    {
        string m_CanName;   //缶の名前

        GameObject m_Bullet;    //Bulletオブジェクト格納用

        Shoot m_Shoot;  //Shootスクリプト

        void Start()
        {
            m_Bullet = GameObject.Find("bullet");
            m_Shoot = m_Bullet.GetComponent<Shoot>();
        }

        void Update()
        {
            if(transform.childCount == 1)
            {
                GameObject m_Child = transform.GetChild(0).gameObject;    //子のオブジェクトを取得

                //switch文
                switch(m_Child.name)
                {
                    //条件1
                    case "GrapeCan":
                        //処理1
                        m_Shoot.m_Num = 0;
                        //break文
                        break;

                    //条件2
                    case "StrawberryCan":
                        //処理2
                        m_Shoot.m_Num = 1;
                        //break文
                        break;

                    //条件3
                        case "MintCan":
                        //処理3
                        m_Shoot.m_Num = 2;
                        //break文
                        break;

                    //デフォルト処理
                    default:
                        //処理Default
                        m_Shoot.m_Num = 3;
                        //Debug.Log("Default");
                        //break文
                        break;
                }
            }
            else
            {
                m_Shoot.m_Num = 3;
            }
        }
    }
}
