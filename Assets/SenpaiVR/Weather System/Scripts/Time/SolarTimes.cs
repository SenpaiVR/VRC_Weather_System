
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
using System;

namespace SenpaiVR.Time
{
    public class SolarTimes : UdonSharpBehaviour
    {
        #region Calculation Functions

            #region Stellar Equations

                    public float calctimenoon(float jd, float le, float ln, float tzone)
                    {
                        float jangle_est = jd + 0.5f - le / 360;
                        float t = jcent(jangle_est);
                        float eqtime = EquationOfTime(t);
                        float dayfrac_est = 0.5f - eqtime / 1440 + tzone / 24 - le / 360;
                        jangle_est = jd + dayfrac_est - tzone / 24;
                        float dayfrac = 0.5f - eqtime / 1440 + tzone / 24 - le / 360;
                        return dayfrac;
                    }
                    public float calctimeangle(float postnoon, float angle, float jd, float le, float ln, float tzone)
                    {
                        float f;
                        if (postnoon == 1)
                        {
                            f = 1;
                        }
                        else
                        {
                            f = -1;
                        }
                        float jangle_est = jd + f * 0.25f - le / 360;
                        float t = jcent(jangle_est);
                        float eqtime = EquationOfTime(t);
                        float ha = HourAngle(t, angle, ln);
                        float dayfrac_est = 0.5f + f * ha / 360 - eqtime / 1440 + tzone / 24 - le / 360;
                        jangle_est = jd + dayfrac_est - tzone / 24;
                        t = jcent(jangle_est);
                        eqtime = EquationOfTime(t);
                        ha = HourAngle(t, angle, ln);
                        float dayfrac = 0.5f + f * ha / 360 - eqtime / 1440 + tzone / 24 - le / 360;
                        return dayfrac;
                    }
                    public float GeomMeanSunLong(float t)
                    {
                        return (280.46645f + t * (36000.76983f + t * 0.0003032f)) % 360;

                    }
                    public float GeomMeanAnomalySun(float t)
                    {
                        return (357.52910f + 35999.05030f * t - 0.0001559f * t * t - 0.00000048f * t * t * t) % 360;

                    }
                    public float SunEquationOfCenter(float t, float M)
                    {
                        return (float)(dsin(M) * (1.914602f - 0.004817f * t + 0.000014f * t * t) + dsin(2 * M) * (0.019993f - 0.000101f * t) + dsin(3 * M) * 0.000289f);

                    }
                    public float EarthEccentricity(float t)
                    {
                        return 0.016708634f - 0.000042037f * t + 0.0000001267f * t * t;

                    }
                    public float SunApparentLong(float t, float L0, float C)
                    {
                        return (float)(L0 + C - 0.00569f - 0.00478f * dsin(125.04f - 1934.136f * t));

                    }
                    public float MeanObliquityEcliptic(float t)
                    {
                        return 23 + (26 + (21.448f - 46.815f * t + 0.00059f * t * t - 0.001813f * t * t * t) / 60) / 60;

                    }
                    public float ObliquityCorrection(float t, float epsilon0)
                    {
                        return (float)(epsilon0 + 0.00256f * dcos(125.04f - 1934.136f * t));

                    }
                    public float SunRightAscension(float t, float lambda, float epsilon)
                    {
                        return (float)(180 / Math.PI * Mathf.Atan2((float)dcos(lambda), (float)dcos(epsilon) * (float)dsin(lambda)));

                    }
                    public float SunDeclination(float t)
                    {
                        return (float)23.45f*Mathf.Sin((360f/365f*(t-81f))*Mathf.Deg2Rad);
                    }
                    public float EquationOfTime(float t)
                    {
                        float L0 = GeomMeanSunLong(t);
                        float M = GeomMeanAnomalySun(t);
                        float e = EarthEccentricity(t);
                        float epsilon0 = MeanObliquityEcliptic(t);
                        float epsilon = ObliquityCorrection(t, epsilon0);
                        float y = Mathf.Pow((float)dtan(epsilon / 2), 2);
                        return (float)(4 * 180 / Math.PI * (y * dsin(2 * L0) - 2 * e * dsin(M) + 4 * e * y * dsin(M) * dcos(2 * L0) - 0.5 * y * y * dsin(4 * L0) - 1.25 * e * e * dsin(2 * M)));

                    }
                    public float HourAngle(float t, float angle, float ln)
                    {
                        float theta = SunDeclination(t);
                        return (float)(180 / Math.PI * (Mathf.Acos((float)((dsin(angle) - dsin(ln) * dsin(theta)) / (dcos(ln) * dcos(theta))))));

                    }

                #endregion

            #region Math Equations
                public float cdtojd(int nyear, int nmonth, int nday)
                {
                    int B = 0;
                    if (nmonth <= 2)
                    {
                        nyear -= 1;
                        nmonth += 12;
                    }
                    if (nyear > 1582)
                    {
                        int A = (int)Mathf.Floor(nyear / 100);
                        B = (int)(2 - A + Mathf.Floor(A / 4));
                    }
                    else
                    {
                        B = 0;
                    }
                    float JD = Mathf.Floor(365.25f * (nyear + 4716)) + Mathf.Floor(30.60001f * (nmonth + 1)) + nday + B - 1524.5f;
                    return JD;
                }
                public float jcent(float jd)
                {
                    return (jd - 2451545) / 36525;
                }
                public float dsin(float d)
                {
                    return Mathf.Sin((float)(d * Math.PI / 180f));
                }
                public float dcos(float d)
                {
                    return Mathf.Cos((float)(d * Math.PI / 180f));
                }
                public float dtan(float d)
                {
                    return Mathf.Tan((float)(d * Math.PI / 180f));
                }

                #endregion

        #endregion

        #region Public Functions
            float angle_riseset = -50f / 60f;
            float angle_twilight = -6.0f;
            public DateTime _TimeOfDawn(DateTime date, float longitude, float latitude)
            {
                #region calculations
                    int nyear = date.Year;
                    int nmonth = date.Month;
                    int nday = date.Day;
                    float ln = latitude;
                    float le = longitude;
                    float tzone = (float)Math.Floor(longitude / 15f);

                    float jd = cdtojd(nyear, nmonth, nday);

                    float dawn = calctimeangle(0f, angle_twilight, jd, le, ln, tzone);
                    float noon = calctimenoon(jd, le, ln, tzone);
                    float jnoon = jd + noon - tzone / 24f;

                    float t = jcent(jnoon);
                    float theta = SunDeclination(t);
                    float elev_midday = (float)(180 / Math.PI * (dcos(0f) * dcos(ln) * dcos(theta) + dsin(ln) * dsin(theta)));
                    float elev_midnight = (float)(180 / Math.PI * (dcos(180f) * dcos(ln) * dcos(theta) + dsin(ln) * dsin(theta)));

                    DateTime dawnVal = new DateTime(date.Year, date.Month, date.Day, 0, 0, 0);
                #endregion
                
                if (elev_midday >= angle_riseset && elev_midnight > angle_twilight && elev_midnight < angle_riseset)
                {
                    Debug.Log("It never gets darker than twilight on this date. Returning 1 day less as a warning! Consider Dawn 'NULL'");
                    dawnVal = dawnVal.AddDays(-1);
                    
                    return dawnVal; // It never gets darker than twilight on this date. 
                }
                else if (elev_midnight > angle_riseset || elev_midday < angle_twilight)
                {
                    Debug.Log("It is either purpetual Daytime or Purpetual NightTime. Returning 1 day less as a warning. Consider Dawn 'NULL'");
                    dawnVal = dawnVal.AddDays(-1);

                    return dawnVal; // It is either purpetual Daytime or Purpetual NightTime
                }
                else if (elev_midday > angle_twilight && elev_midday < angle_riseset && elev_midnight <= angle_twilight)
                {
                    dawnVal = dawnVal.AddMinutes(Mathf.Lerp(0, 1440, dawn));
                    return dawnVal;
                }
                else if (elev_midday > angle_twilight && elev_midday < angle_riseset && elev_midnight > angle_twilight && elev_midnight < angle_riseset)
                {
                    Debug.Log("Location is in perpetual twilight on this date. Returning 1 day less as a warning. Consider Dawn 'NULL'");
                    dawnVal = dawnVal.AddDays(-1);

                    return dawnVal; //location is in perpetual twilight on this date
                }
                else
                {
                    dawnVal = dawnVal.AddMinutes(Mathf.Lerp(0, 1440, dawn));
                    return dawnVal;
                }
            }

            public DateTime _TimeOfSunrise(DateTime date, float longitude, float latitude)
            {
                #region calculations
                    int nyear = date.Year;
                    int nmonth = date.Month;
                    int nday = date.Day;
                    float ln = latitude;
                    float le = longitude;
                    float tzone = (float)Math.Floor(longitude / 15f);

                    float jd = cdtojd(nyear, nmonth, nday);
                    float noon = calctimenoon(jd, le, ln, tzone);
                    float jnoon = jd + noon - tzone / 24f;

                    float t = jcent(jnoon);
                    float theta = SunDeclination(t);
                    float elev_midday = (float)(180 / Math.PI * (dcos(0f) * dcos(ln) * dcos(theta) + dsin(ln) * dsin(theta)));
                    float elev_midnight = (float)(180 / Math.PI * (dcos(180f) * dcos(ln) * dcos(theta) + dsin(ln) * dsin(theta)));

                    float rise = calctimeangle(0f, angle_riseset, jd, le, ln, tzone);
                    float jrise = jd + rise - tzone / 24f;

                    DateTime sunriseVal = new DateTime(date.Year, date.Month, date.Day, 0, 0, 0);
                #endregion

                if (elev_midday >= angle_riseset && elev_midnight > angle_twilight && elev_midnight < angle_riseset)
                {
                    sunriseVal = sunriseVal.AddMinutes(Mathf.Lerp(0, 1440, rise));
                    return sunriseVal;
                }
                else if (elev_midnight > angle_riseset || elev_midday < angle_twilight)
                {
                    Debug.Log("It is either purpetual Daytime or Purpetual NightTime. Returning 1 day less as a warning. Consider Sunrise 'NULL'");
                    sunriseVal = sunriseVal.AddDays(-1);
                    
                    return sunriseVal;
                }
                else if (elev_midday > angle_twilight && elev_midday < angle_riseset && elev_midnight <= angle_twilight)
                {
                    Debug.Log("location never gets brighter than twilight on this date, so there is no sunrise or sunset. Returning 1 day less as a warning. Consider Sunrise 'NULL'");
                    sunriseVal = sunriseVal.AddDays(-1);
                    return sunriseVal;
                }
                else if (elev_midday > angle_twilight && elev_midday < angle_riseset && elev_midnight > angle_twilight && elev_midnight < angle_riseset)
                {
                    Debug.Log("location is in perpetual twilight on this date. This can happen at high latitudes. Returning 1 day less as a warning. Consider Sunrise 'NULL'");
                    sunriseVal = sunriseVal.AddDays(-1);
                    return sunriseVal;
                }
                else
                {
                    sunriseVal = sunriseVal.AddMinutes(Mathf.Lerp(0, 1440, rise));
                    return sunriseVal;
                }
            }

            public DateTime _TimeOfNoon(DateTime date, float longitude, float latitude)
            {
                #region calculations
                    DateTime noonVal = new DateTime(date.Year, date.Month, date.Day, 0, 0, 0);
                    int nyear = date.Year;
                    int nmonth = date.Month;
                    int nday = date.Day;
                    float ln = latitude;
                    float le = longitude;
                    float tzone = (float)Math.Floor(longitude / 15f);

                    float jd = cdtojd(nyear, nmonth, nday);
                    float noon = calctimenoon(jd, le, ln, tzone);
                #endregion
                
                noonVal = noonVal.AddMinutes(Mathf.Lerp(0, 1440, noon));

                return noonVal;
            }

            public DateTime _TimeOfSunset(DateTime date, float longitude, float latitude)
            {
                #region calculations
                    int nyear = date.Year;
                    int nmonth = date.Month;
                    int nday = date.Day;
                    float ln = latitude;
                    float le = longitude;
                    float tzone = (float)Math.Floor(longitude / 15f);

                    float jd = cdtojd(nyear, nmonth, nday);
                    float noon = calctimenoon(jd, le, ln, tzone);
                    float jnoon = jd + noon - tzone / 24f;

                    float t = jcent(jnoon);
                    float theta = SunDeclination(t);
                    float elev_midday = (float)(180 / Math.PI * (dcos(0f) * dcos(ln) * dcos(theta) + dsin(ln) * dsin(theta)));
                    float elev_midnight = (float)(180 / Math.PI * (dcos(180f) * dcos(ln) * dcos(theta) + dsin(ln) * dsin(theta)));

                    float set = calctimeangle(1f, angle_riseset, jd, le, ln, tzone);
                    float jset = jd + set - tzone / 24f;

                    DateTime sunsetVal = new DateTime(date.Year, date.Month, date.Day, 0, 0, 0);

                #endregion

                if (elev_midday >= angle_riseset && elev_midnight > angle_twilight && elev_midnight < angle_riseset)
                {
                    sunsetVal = sunsetVal.AddMinutes(Mathf.Lerp(0, 1440, set));
                    return sunsetVal;
                }
                else if (elev_midnight > angle_riseset || elev_midday < angle_twilight)
                {
                    Debug.Log("It is either purpetual Daytime or Purpetual NightTime. Returning 1 day less as a warning. Consider Sunset 'NULL'");
                    sunsetVal = sunsetVal.AddDays(-1);

                    return sunsetVal;
                }
                else if (elev_midday > angle_twilight && elev_midday < angle_riseset && elev_midnight <= angle_twilight)
                {
                    Debug.Log("Location never gets brighter than twilight on this date, so there is no sunrise or sunset. Returning 1 day less as a warning. Consider Sunset 'NULL'");
                    sunsetVal = sunsetVal.AddDays(-1);
                    return sunsetVal;
                }
                else if (elev_midday > angle_twilight && elev_midday < angle_riseset && elev_midnight > angle_twilight && elev_midnight < angle_riseset)
                {
                    Debug.Log("Location is in perpetual twilight on this date. This can happen at high latitudes. Returning 1 day less as a warning. Consider Sunset 'NULL'");
                    sunsetVal = sunsetVal.AddDays(-1);
                    return sunsetVal;
                }
                else
                {
                    sunsetVal = sunsetVal.AddMinutes(Mathf.Lerp(0, 1440, set));
                    return sunsetVal;
                }
            }

            public DateTime _TimeOfDusk(DateTime date, float longitude, float latitude)
            {
                #region calcuations
                    int nyear = date.Year;
                    int nmonth = date.Month;
                    int nday = date.Day;
                    float ln = latitude;
                    float le = longitude;
                    float tzone = (float)Math.Floor(longitude / 15f);

                    float jd = cdtojd(nyear, nmonth, nday);
                    float noon = calctimenoon(jd, le, ln, tzone);
                    float jnoon = jd + noon - tzone / 24f;

                    float t = jcent(jnoon);
                    float theta = SunDeclination(t);
                    float elev_midday = (float)(180 / Math.PI * (dcos(0f) * dcos(ln) * dcos(theta) + dsin(ln) * dsin(theta)));
                    float elev_midnight = (float)(180 / Math.PI * (dcos(180f) * dcos(ln) * dcos(theta) + dsin(ln) * dsin(theta)));

                    float dusk = calctimeangle(1f, angle_twilight, jd, le, ln, tzone);

                    DateTime duskVal = new DateTime(date.Year, date.Month, date.Day, 0, 0, 0);
            #endregion

                if (elev_midday >= angle_riseset && elev_midnight > angle_twilight && elev_midnight < angle_riseset)
                {
                    Debug.Log("It never gets darker than twilight on this date. Returning 1 day less as a warning! Consider Dawn 'NULL'");
                    duskVal = duskVal.AddDays(-1);

                    return duskVal; // It never gets darker than twilight on this date. 
                }
                else if (elev_midnight > angle_riseset || elev_midday < angle_twilight)
                {
                    Debug.Log("It is either purpetual Daytime or Purpetual NightTime. Returning 1 day less as a warning. Consider Dawn 'NULL'");
                    duskVal = duskVal.AddDays(-1);

                    return duskVal; // It is either purpetual Daytime or Purpetual NightTime
                }
                else if (elev_midday > angle_twilight && elev_midday < angle_riseset && elev_midnight <= angle_twilight)
                {
                    duskVal = duskVal.AddMinutes(Mathf.Lerp(0, 1440, dusk));
                    return duskVal;
                }
                else if (elev_midday > angle_twilight && elev_midday < angle_riseset && elev_midnight > angle_twilight && elev_midnight < angle_riseset)
                {
                    Debug.Log("Location is in perpetual twilight on this date. Returning 1 day less as a warning. Consider Dawn 'NULL'");
                    duskVal = duskVal.AddDays(-1);

                    return duskVal; //location is in perpetual twilight on this date
                }
                else
                {
                    duskVal = duskVal.AddMinutes(Mathf.Lerp(0, 1440, dusk));
                    return duskVal;
                }

            }
        #endregion
    }
}
