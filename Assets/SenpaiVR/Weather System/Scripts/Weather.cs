
using VRC.SDKBase;
using VRC.Udon;
using UdonSharp;
using UnityEngine;
using System;

public class Weather : UdonSharpBehaviour
{

    #region Custom Variables
    [Header("Editable Variables")]
    [SerializeField, Tooltip("Input a Longitude for your location in decimal form. Positive numbers are East. Negative Numbers are West If you want consistant time with other worlds, I advice you to keep this on 0")]
        private float longitude = 0;
    [SerializeField, Tooltip("Input a Latitude for your location in decimal form. Positive numbers are north. Negative Numbers are South")]
        private float latitude;
    [Space]
    #endregion

    #region Reference Variables
    [Header("Reference Variables")]
    [SerializeField] Material skyMaterial;
    [SerializeField] private Light sun;
    [SerializeField] private ParticleSystem rain;
    [SerializeField] private SFXLiberary SoundEffectLiberary;
    [SerializeField] private ParticleSystem lightning;
    
    [SerializeField] private SenpaiVR.Time.SolarTimes SolarTimes;
    [Space]
    #endregion
    [Space]

    #region Debug Items
    [Header("Debug Items")]//Hide when released

    [SerializeField] private bool debugMode;
    [Range(1, 12)] public int _debugMonth = 01;
    [Range(1, 31)] public int _debugDay = 01;
    [Min(2000)] public int _debugYear = 2022;
    [Range(1, 366)] public int _dayOfYear = 1;

    [Space]

    [Range(0, 23)] public int _debugHour = 12;
    [Range(0, 59)] public int _debugMinute = 00;
    [Range(0, 59)] public int _debugSeconds = 00;

    [SerializeField] GameObject _debugCharacter;
    #endregion
    [Space]

    private DateTime RainStart;
    private DateTime RainEnd;
    [Space]

    [Space]
    [SerializeField] private Vector3 stormCoord1;
    [SerializeField] private Vector3 stormCoord2;
    [SerializeField] private float worldHeight;

    bool dateCustom = false;

    #region Local Variables

    #region Date Time
    private DateTime utcNow;
    int month;
    int day;
    int year;

    int hour;
    int minute;
    int seconds;
    #endregion

    #region Weather Booleans
    private bool rainStarting = false;
    private bool handlingRain = false;
    private bool rainEnding = false;
    private bool isRaining = false;
    private bool willRain = false;
    private bool isStorm = false;
    private bool strikePlanned = false;
    #endregion

    #region Weather Audio Sources
    private AudioSource sfxRain;
    private AudioSource sfxWind;
    private AudioSource[] LightningClose;
    private AudioSource[] LightningMedium;
    private AudioSource[] LightningFar;
    #endregion

    #endregion

    void Start()
    {
        #region audiosfx
        //Set Array Length
        LightningClose = new AudioSource[SoundEffectLiberary.LightningClose.Length];
        LightningMedium = new AudioSource[SoundEffectLiberary.LightningMedium.Length];
        LightningFar = new AudioSource[SoundEffectLiberary.LightningFar.Length];

        //Add to script asset liberary;
        sfxRain = SoundEffectLiberary.Rain;
        sfxWind = SoundEffectLiberary.Wind;

        for (int i = 0; i < LightningClose.Length; i++)
            LightningClose[i] = SoundEffectLiberary.LightningClose[i];

        for (int i = 0; i < LightningMedium.Length; i++)
            LightningMedium[i] = SoundEffectLiberary.LightningMedium[i];

        for (int i = 0; i < LightningFar.Length; i++)
            LightningFar[i] = SoundEffectLiberary.LightningFar[i];
        #endregion

        if (debugMode)
        {
            debugDateTime();
        }
        else
        {
            getDate();
        }

        dateToWeather();

        skyMaterial.SetFloat("_North", (360 - transform.eulerAngles.y));
    }

    void Update() {
        if(!debugMode)
        {
            utcNow = DateTime.UtcNow;
            _dayOfYear = utcNow.DayOfYear;
            SunRotation();
            dateCustom = false;
        }

        if(debugMode)
        {
            if(dateCustom == false)
            {
                debugDateTime();
                dateCustom = true;
            }
        }

        if (willRain)
        {
            if (0 > (RainStart - utcNow).TotalHours && (utcNow - RainStart).TotalMinutes < 5)
            {
                //if (rainStarting == false && isRaining == false) { rainStarting = true; SendCustomEventDelayedSeconds("_StartRain", 1f); }
            }
            else if ((utcNow - RainStart).TotalMinutes > 5 && (RainEnd - utcNow).TotalMinutes > 5) // Late Joiners
            {
                if (handlingRain == false)
                {
                    handlingRain = true;
                    //SendCustomEventDelayedSeconds("_Rain", 1f);
                }
            }
            else if ((RainEnd - utcNow).TotalMinutes < 5) //Rain is ending
            {
                if (!rainEnding) { rainEnding = true; }
                //SendCustomEvent("_EndRain");
            }
            else if ((RainEnd - utcNow).TotalMinutes <= 0 && sfxRain.isPlaying)// It is no longer raining
            {

            }
        }
        
    }
    private void getDate() {
        string utcmonth = DateTime.UtcNow.ToString("MM");
        string utcday = DateTime.UtcNow.ToString("dd");
        string utcyear = DateTime.UtcNow.ToString("yyyy");

        string utchour = DateTime.UtcNow.ToString("HH");
        string utcminute = DateTime.UtcNow.ToString("mm");
        string utcseconds = DateTime.UtcNow.ToString("ss");

        string localmonth = DateTime.Now.ToString("MM");
        string localday = DateTime.Now.ToString("dd");
        string localyear = DateTime.Now.ToString("yyyy");

        string localhour = DateTime.Now.ToString("HH");
        string localminute = DateTime.Now.ToString("mm");
        string localseconds = DateTime.Now.ToString("ss");

        utcNow = DateTime.UtcNow;
    }

    private void debugDateTime(){
        
        month = _debugMonth;
        day = _debugDay;
        year = _debugYear;
        hour = _debugHour;
        minute = _debugMinute;
        seconds = _debugSeconds;
        utcNow = new DateTime(year, month, day, hour, minute, seconds);

        _dayOfYear = utcNow.DayOfYear;
    }

    private void dateToWeather() {
        //Use Month Date and Year to create a weather schedule throughout the day.
        //Month will always be between 1 and 12
        //day will always be between 1 and 31
        //year will always be greater than 2000
        //always 24 hours in a date

        //Chance of Rain
        UnityEngine.Random.InitState(month+day+year);
        double chanceOfPrecip = Math.Round((UnityEngine.Random.Range(111111111111, 999999999999)/1000000000000), 2);
        float weatherPerc = Convert.ToSingle(chanceOfPrecip);
        int weatherType = CheckWeather(weatherPerc);
        if(weatherType == 3) { //Stormy
            //When in the day will it storm and how long
            int minuteStart = UnityEngine.Random.Range(UnityEngine.Random.Range(1,1440),UnityEngine.Random.Range(1,1440));
            int durr = UnityEngine.Random.Range(1, 240);

            //Convert Hour minute to Hour hour
            float hourConversion = (float)Math.Round(((float)(minuteStart) / (60.0f)), 2);
            int startHour = (int)Math.Floor(hourConversion);
            int startMinute = (int)(Math.Floor((hourConversion - Math.Truncate(hourConversion))*60));
            
            DateTime weatherStart = new DateTime(year, month, day, startHour, startMinute, 0);
            DateTime weatherEnd = weatherStart.AddMinutes(durr);

            willRain = true;
            isStorm = true;
            RainStart = weatherStart;
            RainEnd = weatherEnd;
        }
        else if (weatherType == 2)
        { // Rainy
            //When in the day will it rain and for how long
            int minuteStart = UnityEngine.Random.Range(UnityEngine.Random.Range(1,1440),UnityEngine.Random.Range(1,1440)); // 1440 minutes in a day
            int durr = UnityEngine.Random.Range(1, 1440); // 1440 minutes in a day
            
            //Convert Hour minute to Hour hour
            float hourConversion = (float)Math.Round(((float)(minuteStart) / (60.0f)), 2);
            int startHour = (int)Math.Floor(hourConversion);
            int startMinute = (int)(Math.Floor((hourConversion - Math.Truncate(hourConversion))*60));
            
            DateTime weatherStart = new DateTime(year, month, day, startHour, startMinute, 0);
            DateTime weatherEnd = weatherStart.AddMinutes(durr);

            willRain = true;
            isStorm = false;
            RainStart = weatherStart;
            RainEnd = weatherEnd;

        } else if (weatherType == 1) { //make it cloudy all day
            willRain = false;
        } else { //make it sunny all day
            willRain = false;
        }
        if(minute == 0)
        {
            SendCustomEvent("dateToWeather");
        }
        if (debugMode)
        {
            SendCustomEventDelayedSeconds("_changeTime", 1f);
        }
    }

    public void _changeTime()
    {
        //if(seconds == 59) {
            //seconds = 0;
            if (minute == 59)
            {
                minute = 0;
                if (hour == 23)
                {
                    hour = 0;
                    if(day == DateTime.DaysInMonth(year, month)) {
                    //if (day > 1)
                    //{
                        day = 1;
                        if (month == 12)
                        {
                            month = 1;
                            year++;
                        }
                        else
                        {
                            month++;
                        }
                    }
                    else
                    {
                        day++;
                    }
                }
                else
                {
                    hour++;
                }
            }
            else
            {
                minute ++;
            }
        //} else {
        //    seconds ++;
        //}
        utcNow = new DateTime(year, month, day, hour, minute, seconds);
        _dayOfYear = utcNow.DayOfYear;
        SunRotation();
        dateToWeather();
    }

    #region Sun Rotation
    public void SunRotation()
    {


        #region calculation

        string debugger;
        float LAT = latitude;
        float LONG = longitude;
        float time_zone = LONG / 15;
        DateTime localDate = utcNow.AddHours(Mathf.Floor(time_zone) + (time_zone < 0 ? 1 : 0));

        float theTime = (float)localDate.TimeOfDay.TotalMinutes;
        float dayNo = localDate.DayOfYear;
        float DEC = SolarTimes.SunDeclination(dayNo);
        DEC *= Mathf.Deg2Rad;
        LAT *= Mathf.Deg2Rad;

        float B = 360 / 365 * (dayNo - 81) * Mathf.PI / 180;
        float EOT  = (float)(9.87f * Mathf.Sin(2 * B) - 7.53f * Mathf.Cos(B) - 1.5 * Mathf.Sin(B));
        float LSTM = 15 * time_zone;
        float time_correction = EOT + 4 * (LONG - LSTM);

        float LST = +(theTime / 60) + time_correction / 60;

        float HRA = 15 * (LST - 12);
        HRA *= Mathf.Deg2Rad;
        float alt = Mathf.Asin((Mathf.Sin(DEC) * Mathf.Sin(LAT)) + (Mathf.Cos(DEC) * Mathf.Cos(LAT) * Mathf.Cos(HRA)));
        float azi = Mathf.Acos((Mathf.Cos(LAT) * Mathf.Sin(DEC) - Mathf.Cos(DEC) * Mathf.Sin(LAT) * Mathf.Cos(HRA)) / Mathf.Cos(alt));
        float zen = 90*Mathf.Deg2Rad - alt;
        if (HRA > 0) azi = 2 * Mathf.PI - azi;
        float elevation = alt * Mathf.Rad2Deg;
        float zenith = ((Mathf.PI / 2 - alt) * Mathf.Rad2Deg);
        float azimuth = azi * Mathf.Rad2Deg;

        #endregion

        sun.transform.localEulerAngles = new Vector3(elevation, azimuth, 0);

        StarPosition((float)theTime);
        sunColorTemp((float)elevation);
        }

    #endregion

    #region Star position
        private void StarPosition(float T)
        {
            skyMaterial.SetFloat("_Declination", (float)latitude);
            float offset = ((longitude / 15) * 60); // Returns timeoffset in minutes
            float newTime = T + offset;
            if (newTime > 1440) newTime -= 1440;
            if (newTime < 0) newTime += 1440;
            float starRotation = Mathf.Lerp(0, 360, newTime / 1440);
            skyMaterial.SetFloat("_WorldRotation", starRotation);
        }
    #endregion

    #region Sun Color
        private void sunColorTemp(float alt)
        {
            #region Color Temperature
                
                float zenith = alt / 90;
                float log = Mathf.Sqrt(zenith);
                if(zenith <= 0 || zenith > 1)  log = 0;
                float colorTemp = Mathf.Lerp(2000, 6000, log);
                sun.colorTemperature = colorTemp;
            #endregion

            #region Sun Intensity
            if(alt <= 1 && alt >= 0)
            {
                sun.intensity = sun.transform.localEulerAngles.x;
            } 
            else if(alt >= 1)
            {
                sun.intensity = 1;
            } 
            else if(alt <= 1)
            {
                sun.intensity = 0;
            }
            

            #endregion
        }

    #endregion

    #region Weather
    public void _StartRain()
    {
        if(!isRaining) isRaining = true;
        var main = rain.main;
        var emission = rain.emission;
        var velocity = rain.velocityOverLifetime;
        if (emission.rateOverTime.constant < 3000 && (RainStart - utcNow).TotalMinutes < 3) //Rain is starting
        {
            emission.rateOverTime = emission.rateOverTime.constant + (3000 / 120);
            if(sfxRain.isPlaying == false) { sfxRain.Play(); }
            sfxRain.volume = Mathf.Lerp(0, 1, emission.rateOverTime.constant / 3000f);
        }
        else if (isStorm && velocity.speedModifier.constant <= 2) // rain is a storm
        {
            velocity.speedModifier = velocity.speedModifier.constant +  (1f / 30f);
            float vel = velocity.speedModifier.constant - 1;
            if (sfxWind.isPlaying == false) { sfxWind.Play(); }
            sfxWind.volume = Mathf.Lerp(0, 1, vel);
        }
        else
        {
            rainStarting = false;
            isRaining = true;
        }
        if(rainStarting == true) SendCustomEventDelayedSeconds("_StartRain", 1f);
    }

    public void _Rain()
    {
        var main = rain.main;
        var velocity = rain.velocityOverLifetime;
        
        if(isRaining && rainEnding == false && (RainEnd - utcNow).TotalMinutes > 5) //Check if it is scheduled to rain
        {
            if (sfxRain.isPlaying == false && main.maxParticles < 1000) {
                main.maxParticles = 1000; main.maxParticles = 1000; 
                sfxRain.Play(); sfxRain.volume = 100; 
            }
            if (isStorm && velocity.speedModifier.constant < 2f) { velocity.speedModifier = 2f; sfxWind.Play(); sfxWind.volume = 1; }

            if (isStorm)
            {
                UnityEngine.Random.InitState(hour + minute);
                float x = UnityEngine.Random.Range(stormCoord1.x, stormCoord2.x);
                float y = UnityEngine.Random.Range(worldHeight, worldHeight);
                float z = UnityEngine.Random.Range(stormCoord1.z, stormCoord2.z);
                Vector3 strike = new Vector3(x, y, z);
                if (strikePlanned == false)
                {
                    strikePlanned = true;
                    SendCustomEventDelayedSeconds("_Lightning", UnityEngine.Random.Range(60f, 360f)/10); // Adjusted for 10 second skip debug
                }
            }
            SendCustomEventDelayedSeconds("_Rain", 1f);
        } 
        else // If we should not be raining any more, confirm it should stop
        {
            sfxRain.volume = 0f;
            sfxRain.Stop();
            sfxWind.Stop();
            sfxWind.volume = 0f;
            main.maxParticles = 0;
            velocity.speedModifier = 1f;
        }
        


        

    }

    public void _Lightning()
    {


        //Init
            //Lightning
            lightning.Emit(1);
            ParticleSystem.Particle[] strike = new ParticleSystem.Particle[1];
            lightning.GetParticles(strike);

            
            
            //Thunder
            float delay = Vector3.Distance(strike[0].position, _debugCharacter.transform.position) / 343; //Speed of Sound in Meters per second: 343
            AudioSource thunder;
            int audiofile;

        if (delay > 5)
        {
            audiofile = UnityEngine.Random.Range(0, LightningFar.Length);
            thunder = LightningFar[audiofile];
        } 
        else if (delay >= 3)
        {
            audiofile = UnityEngine.Random.Range(0, LightningMedium.Length);
            thunder = LightningMedium[audiofile];
        } else
        {
            audiofile = UnityEngine.Random.Range(0, LightningClose.Length);
            thunder = LightningClose[audiofile];
        }

        thunder.transform.position = strike[0].position;
        //Thunder
        thunder.PlayDelayed(delay);
        strikePlanned = false;
    }

    public void _EndRain()
    {
        if (handlingRain) handlingRain = false;
        var main = rain.main;
        var velocity = rain.velocityOverLifetime;
        if (isStorm && velocity.speedModifier.constant >= 1f && velocity.speedModifier.constant > 1)
        {
            velocity.speedModifier = velocity.speedModifier.constant - Mathf.Lerp(1, velocity.speedModifier.constant, Time.deltaTime / 5);
            if (velocity.speedModifier.constant <= 1.1f) { velocity.speedModifier = 1f; isStorm = false; }
        }
        else if (main.maxParticles >= 0f)
        {
            main.maxParticles = (int)Mathf.Lerp(main.maxParticles, 0, (Time.deltaTime / 100000f));
            sfxRain.volume -= (float)Mathf.Lerp(0, 100, (Time.deltaTime / 10000f));
            if (sfxRain.volume <= 0) { sfxRain.Stop(); sfxRain.volume = 0f; }
        }
    }

    private int CheckWeather(float rainPercentage) {
        if(rainPercentage >= 0.97f) {
            return 3;
        } else if (rainPercentage >= .75f) {
            return 2;
        } else if (rainPercentage >= .50f) {
            return 1;
        } else {
            return 0;
        }
    }

    #endregion
}
