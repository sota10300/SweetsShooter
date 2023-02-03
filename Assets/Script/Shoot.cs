using System.Net.NetworkInformation;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Valve.VR;
using TMPro;
using UnityEngine.SceneManagement;

namespace Valve.VR.InteractionSystem
{
public class Shoot : MonoBehaviour
{
        [SerializeField]GameObject Bullet;  //弾丸として生成するオブジェクト

        [SerializeField]GameObject m_BulletPoint;   //弾丸を発射する場所

        //ミント弾数
        [SerializeField] int m_mintMaxAmmo = 100;

        int m_mintAmmo;

        //グレープ弾数
        [SerializeField] int m_grapeMaxAmmo = 75;

        int m_grapeAmmo;

        //グレープ弾数
        [SerializeField] int m_strawberryMaxAmmo = 1;

        int m_strawberryAmmo;

        public GameObject m_Tank;

        float m_RecastTime; //攻撃可能までの時間

        public int m_Num; //缶種類

        bool isGrab;    //オブジェクトをつかんでいるか判断

        bool isReload;  //リロード中か判断

        bool isSlot;

        bool isRecast;  //次の攻撃が可能か

        int m_shootCount;

        BlasterSE m_blasterSE;

        GameObject m_grapeCan;

        GameObject m_mintCan;

        GameObject m_strawberryCan;

        bool isCanFind = false;
        //Shootボタンが押されてるのかを判定するためのIuiという関数にSteamVR_Actions.default_Shootを固定
        private SteamVR_Action_Boolean Iui = SteamVR_Actions.default_Shoot;

        //結果の格納用
        public bool m_Shooting;
        void Start()
        {
            isGrab = false;
            m_Shooting = false;
            m_blasterSE = GetComponent<BlasterSE>();
        }

        void Update()
        {
            if(isCanFind && SceneManager.GetActiveScene().name == "Stage1")
            {
                //缶の設定
                m_grapeCan = GameObject.Find("GrapeCan");

                m_mintCan = GameObject.Find("MintCan");

                m_strawberryCan = GameObject.Find("StrawberryCan");

                isCanFind = false;
            }

            if(SceneManager.GetActiveScene().name == "Title" && !isCanFind)
            {
                //弾の残弾を最大にする
                m_mintAmmo = m_mintMaxAmmo;
                m_grapeAmmo = m_grapeMaxAmmo;
                m_strawberryAmmo = m_strawberryMaxAmmo;

                isCanFind = true;
            }


            CanSwitch();

            //トリガーを押しているときm_shootingをtrueに
            m_Shooting = Iui.GetStateDown(SteamVR_Input_Sources.RightHand);

            //トリガーが押されたら
            if(m_Shooting == true && !isRecast)
            {
                //弾丸を生成
                Instantiate (Bullet,m_BulletPoint.transform);

                m_blasterSE.m_audioSource.PlayOneShot(m_blasterSE.m_shootSE[m_Num]);   //SEを再生

                m_shootCount++;

                isRecast = true;

                StartCoroutine("Recast");   //リキャストスタート
            }

            if(m_Num == 3)
            {
                m_shootCount = 0;
            }
        }
        //オブジェクトをつかんだら実行
        private void OnAttachedToHand(Hand hand)
        {
            isGrab = true;
        }
        //手を離したら実行
        private void OnDetachedFromHand(Hand hand)
        {
            isGrab = false;
        }

        void CanSwitch()
        {
            //switch文
            switch(m_Num)
            {
            //条件1
            case 0:
                //処理1
                Bullet = (GameObject)Resources.Load("Grape");

                m_RecastTime = 1;

                //break文
                break;

                //条件2
            case 1:
                //処理2
                Bullet = (GameObject)Resources.Load("Strawberry");

                m_RecastTime = 5;
                //break文
                break;

                //条件3
            case 2:
                //処理3
                Bullet = (GameObject)Resources.Load("Mint");

                m_RecastTime = 0.25f;

                //break文
                break;

            //条件3
            case 3:
                //処理Default
                Bullet = (GameObject)Resources.Load("Normal");

                m_RecastTime = 0.5f;
                //break文
                break;

            //デフォルト処理
            default:
                //処理Default
                Bullet = (GameObject)Resources.Load("Normal");

                m_RecastTime = 0.5f;

                //break文
                break;
            }
        }

        IEnumerator Recast()
        {
            yield return new WaitForSecondsRealtime(m_RecastTime);

            if(m_Num == 0)
            {
                m_grapeAmmo --;
            }
            else if(m_Num == 1)
            {
                m_strawberryAmmo--;
            }
            else if(m_Num == 2)
            {
                m_mintAmmo--;
            }

            if(m_strawberryAmmo <= 0)
            {
                Destroy(m_strawberryCan);
            }

            if(m_grapeAmmo <= 0)
            {
                Destroy(m_grapeCan);
            }

            if(m_mintAmmo <= 0)
            {
                Destroy(m_mintCan);
            }

            isRecast = false;
        }
    }
}
