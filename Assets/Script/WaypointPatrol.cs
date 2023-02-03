using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public class WaypointPatrol : MonoBehaviour
{
    [SerializeField][Tooltip("巡回する地点の配列")]private Transform[] waypoints;

    //アニメーター
    Animator m_animator;

    //通過したポイントの数
    int m_wayPointNum;

    //アニメーション切り替え用トリガー
    bool isAnimWait;

    //お菓子持ち運びトリガー
    bool isCarry;

    //連続スコアアップ防止用
    bool isScoreUp = true;

    Score m_scoreScript;

    NPCSpawn m_NPCSpawn;

    Collider other;

    //運搬時の移動速度
    [SerializeField]float m_carrySpeed;

    //通常時の移動速度
    [SerializeField]float m_walkSpeed;

    //オーディオソース
    AudioSource m_audioSource;

    //プレイヤー弾ヒットSE
    public AudioClip m_bulletHitSE;

    // NavMeshAgentコンポーネントを入れる変数
    private NavMeshAgent navMeshAgent;

    // 現在の目的地
    private int currentWaypointIndex;

    //お菓子の山
    GameObject m_sweetsMountain;
    //お菓子の山スクリプト
    SweetsMountain m_sweetsMountainScript;

    void Start()
    {
        // navMeshAgent変数にNavMeshAgentコンポーネントを入れる
        navMeshAgent = GetComponent<NavMeshAgent>();

        // 最初の目的地を入れる
        navMeshAgent.SetDestination(waypoints[0].position);

        //アニメーター
        m_animator = GetComponent<Animator>();

        //目的地点
        m_wayPointNum = 0;

        //移動速度
        navMeshAgent.speed = m_walkSpeed;

        m_animator.SetInteger("KidsAnim",1);

        //待機
        isAnimWait = false;


        //おかしを運んでいる状態のフラグ
        isCarry = false;

        m_scoreScript = GameObject.Find("Score").GetComponent<Score>();

        m_NPCSpawn = GameObject.Find("NPCSpawnPoint").GetComponent<NPCSpawn>();

        m_audioSource = GetComponent<AudioSource>();

        m_sweetsMountain = GameObject.FindWithTag("Sweets");

        m_sweetsMountainScript = m_sweetsMountain.GetComponent<SweetsMountain>();
    }

    void Update()
    {
        // 目的地点までの距離(remainingDistance)が目的地の手前までの距離(stoppingDistance)以下になったら
        if (navMeshAgent.remainingDistance <= navMeshAgent.stoppingDistance)
        {
            m_wayPointNum++;

            // 目的地の番号を１更新（右辺を剰余演算子にすることで目的地をループさせれる）
            currentWaypointIndex = (currentWaypointIndex + 1) % waypoints.Length;
            // 目的地を次の場所に設定
            navMeshAgent.SetDestination(waypoints[currentWaypointIndex].position);
        }

        //目的地４についたら一時停止
        if(currentWaypointIndex == 4 && !isAnimWait)
        {
            navMeshAgent.speed = 0;
            m_animator.SetInteger("KidsAnim",2);
        }

        //目的地８についたらアニメータリセット
        if(currentWaypointIndex == 8)
        {
            m_animator.SetInteger("KidsAnim",1);
            //物を運んでいるフラグをfalseにする
            isCarry = false;
            isAnimWait = false;
            isScoreUp = true;
        }

        //物を運んでいない状態でゲームオーバーになったら一時停止
        if(!isCarry && m_sweetsMountainScript.m_remainingQuantity <= 0)
        {
            navMeshAgent.speed = 0;
            m_animator.SetBool("isGameOver",true);
        }
    }

    //持ち上げアニメーション終了時に呼び出されるイベント
    void LiftUpEnd()
    {
        m_animator.SetInteger("KidsAnim",3);

        //移動速度を変更
        navMeshAgent.speed = m_carrySpeed;
        isAnimWait = true;

        //おかしの数-1
        m_sweetsMountainScript.m_remainingQuantity--;
    }

    //一時停止するアニメーション開始時に呼び出されるイベント
    void NavStop()
    {
        navMeshAgent.speed = 0;
    }

    //一時停止するアニメーション終了時に呼び出されるイベント
    void NavStart()
    {
        navMeshAgent.speed = m_walkSpeed;
        m_animator.SetBool("isShoot",false);
    }

    //物を運ぶ状態時一時停止するアニメーション終了時に呼び出されるイベント
    void NavCarryStart()
    {
        navMeshAgent.speed = m_carrySpeed;
        m_animator.SetBool("isCarryPanic",false);
        m_animator.SetBool("isNearEnemy",false);
    }

    void ScoreUp()
    {
        if(isScoreUp)
        {
            //スコア加算処理
            m_scoreScript.m_audioSource.PlayOneShot(m_scoreScript.m_scoreUpSE);
            m_scoreScript.m_score++;
            isScoreUp = false;
        }
    }


    void IsCarry()
    {
        //物を運んでいるフラグをtrueにする
        isCarry = true;
    }

    void OnParticleCollision()
    {
        if(isCarry)
        {
            m_animator.SetBool("isCarryPanic",true);
            m_audioSource.PlayOneShot(m_bulletHitSE);
        }
        else
        {
            m_animator.SetBool("isShoot",true);
            m_audioSource.PlayOneShot(m_bulletHitSE);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("PlayerBullet"))
        {
            m_animator.SetBool("isShoot",true);
        }
    }

    void OnTriggerStay(Collider other)
    {
        if(other.CompareTag("Enemy") && !isCarry)
        {
            m_animator.SetBool("isNearEnemy",true);
        }
        else if(other.CompareTag("Enemy") && isCarry)
        {
            m_animator.SetBool("isCarryEnemy",true);
        }
    }

    void OnTriggerExit(Collider other)
    {
        if(other.CompareTag("Enemy") && !isCarry)
        {
            m_animator.SetBool("isNearEnemy",false);
        }
        else if(other.CompareTag("Enemy") && isCarry)
        {
            m_animator.SetBool("isCarryEnemy",false);
        }
    }
}