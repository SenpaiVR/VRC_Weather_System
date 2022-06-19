using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
public class GameSpeedChanger : MonoBehaviour
{
    [Range(0,100)] public int GameSpeed = 1;
    // Update is called once per frame
    void Update()
    {
        Time.timeScale = GameSpeed;  
    }
}
