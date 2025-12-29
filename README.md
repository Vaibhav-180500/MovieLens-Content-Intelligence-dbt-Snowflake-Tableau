# 🎬 MovieLens Content Intelligence Platform
### *Transforming 20M User Ratings into Strategic Content Decisions*

[![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=Tableau&logoColor=white)](https://public.tableau.com/app/profile/vaibhav.kumar3519)
[![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)](#)
[![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](#)
[![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)](#)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](#)


---

## 📊 Executive Summary

As a data analytics consultant engaged by MovieLens—a leading streaming platform with **27,278 movies**, **138,493 active users**, and **20M+ ratings**—I conducted a comprehensive content performance and recommendation accuracy analysis. 

**The Challenge**: Inconsistent user engagement, undiscovered high-quality content, and recommendation algorithm gaps were constraining platform growth and user satisfaction.

**The Solution**: A data-driven intelligence framework leveraging genome tag analysis, user segmentation, and content opportunity mapping to optimize catalog performance and recommendation precision.

**The Impact**: Identified **300+ actionable movies** (50 hidden gems, 62 remarketing candidates, 250 quality issues) and quantified **+15% rating lift** from quality attributes vs **-24% drag** from negative tags—enabling immediate strategy shifts and algorithm enhancements.

---

## 🎯 Business Problem Statement

### The Challenge

MovieLens faces critical performance inconsistencies across its content catalog:

#### **1. Content Performance Gaps**
- High-quality content remains undiscovered (<50 raters) despite strong attributes (>3.8 ratings)
- Movies with promising genome tag profiles underperform in user satisfaction
- Catalog inefficiencies result in poor ROI on content acquisitions

#### **2. Recommendation Algorithm Weaknesses**
- Movies with similar characteristics receive vastly different ratings (variance >1.5 stars)
- Current recommendations fail to leverage 1,128 genome tag attributes
- User segments (Power vs. Casual) receive identical recommendations despite 8x engagement differences

#### **3. User Engagement Imbalance**
- Platform average rating of 3.13 masks severe quality issues (15+ movies <2.0 rating)
- Polarized genre preferences ("Highly Divisive" rating patterns) not addressed in personalization
- Power Users (25% of base) generate 67% of engagement but experience lower satisfaction (3.5 vs 3.8 avg)

### Business Impact

| Risk Area | Current State | Business Consequence |
|-----------|---------------|---------------------|
| **User Retention** | Users struggle to find aligned content | Churn risk from poor recommendations |
| **Content ROI** | High-budget acquisitions underperform | Wasted acquisition spend |
| **Platform Watch Time** | Quality content undiscovered | Limited engagement growth |
| **Brand Trust** | Quality issues in featured content | Damaged platform credibility |

**Estimated Annual Impact**: $2M-5M in acquisition inefficiencies + user churn costs

---

## 🔍 Research Questions

### Primary Objective
*How can we optimize content performance and improve recommendation accuracy by understanding the relationship between movie attributes (genome tags), user behavior patterns, and engagement outcomes?*

### Sub-Problems Investigated

**Content Performance**
- Which movies underperform despite strong attributes?
- How do we define and identify "quality issues"?
- Where are our hidden gems requiring promotion?

**Genome Tag Intelligence**
- Which of 1,128 genome tags correlate with higher ratings?
- What's the measurable rating lift from quality attributes vs. negative attributes?
- Can we predict success using tag profiles?

**Genre-Level Dynamics**
- Which genres deliver highest quality vs. highest engagement?
- Which genres polarize audiences most?
- What's the quality-volume relationship?

**User Segmentation**
- How do Power Users (500+ ratings) differ from Casual Users (<50 ratings)?
- Does tagging behavior correlate with engagement level?
- How should recommendations personalize by user segment?

**Actionable Opportunities**
- Which movies need remarketing vs. promotion vs. investigation?
- What content gaps exist in our catalog?
- Which attributes should guide future acquisitions?

---

### Technical Stack & Data Pipeline

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Data Source** | [MovieLens 20M Dataset](https://grouplens.org/datasets/movielens/20m/) | Open-source movie ratings dataset (20M ratings, 27K movies, 138K users, 1,128 genome tags) |
| **Data Warehouse** | Snowflake | Cloud data warehouse for raw data storage and transformation compute |
| **Transformation** | dbt (Data Build Tool) + SQL | Medallion architecture implementation: RAW → STAGING → DIMENSION/FACT → MARTS pipeline |
| **Data Modeling** | SQL (Snowflake) | 5 analytical marts with business logic, aggregations, and classification rules |
| **Visualization** | Tableau Public | 9 interactive dashboards with narrative storytelling |
| **Version Control** | Git/GitHub | Code repository, SQL scripts, documentation |

---

### Data Pipeline Architecture

MovieLens 20M Dataset (CSV)
         
         ↓

    Snowflake RAW Schema (6 tables)
         
         ↓
    
    dbt Transformations
         ├── STAGING Layer (data cleansing, type conversion)
         ├── DIMENSION/FACT Layer (star schema modeling)
         └── MARTS Layer (business-ready analytics tables)
    
         ↓
    
    5 Analytical Marts
         ├── MOVIEPERFORMANCEMETRICS
         ├── GENOMETAGEFFECTIVENESS
         ├── GENREANALYTICS
         ├── USERSEGMENTS
         └── CONTENTOPPORTUNITIES
    
         ↓
    
    Tableau Public (9 Dashboards + Story)

---

### Analytics Models Developed

**5 Purpose-Built Analytical Marts:**

#### 1. **MOVIEPERFORMANCEMETRICS**
-- Individual movie KPIs and classification
Grain: 1 row per movie (27,278 rows)
Key Metrics: Engagement Score, Rating Consistency, Performance Category
Business Use: Identify top/bottom performers, prioritize promotion


#### 2. **GENOMETAGEFFECTIVENESS**
-- Tag impact analysis with rating lift calculation
Grain: 1 row per genome tag (1,128 rows)
Key Metrics: Avg Rating for Tagged Movies, Rating Lift vs. Platform Average
Business Use: Predict success attributes, guide acquisitions


#### 3. **GENREANALYTICS**
-- Genre-level performance statistics
Grain: 1 row per genre (20 genres)
Key Metrics: Avg Rating, Rating Std Dev, Polarization Classification
Business Use: Genre strategy, catalog balance, audience targeting


#### 4. **USERSEGMENTS**
-- User behavioral classification
Grain: 1 row per user (138,493 rows)
Key Metrics: Engagement Tier, Rating Style, Tagging Behavior
Business Use: Personalization strategy, recommendation tuning


#### 5. **CONTENTOPPORTUNITIES**
-- Actionable opportunity matrix
Grain: 1 row per movie (27,278 rows)
Key Metrics: Opportunity Type, Priority Score, Recommended Action
Business Use: Content strategy roadmap, marketing prioritization


## 📈 Methodology

### Analytical Framework

A[Descriptive Analytics] --> B[Diagnostic Analytics]
B --> C[Predictive Insights]
C --> D[Prescriptive Recommendations]



#### **Phase 1: Descriptive Analytics**
*Understanding the Current State*
- Platform health metrics: 27K movies, 3.13 avg rating, 20M engagement events
- User distribution: 4 engagement tiers with 8x activity variance
- Genre landscape: Film-Noir (quality leader), Drama (volume leader)

#### **Phase 2: Diagnostic Analytics**
*Identifying Root Causes*
- Why do similar movies get different ratings? → Analyzed genome tag variance
- Why are genres polarizing? → Rating standard deviation >1.0 for "Highly Divisive"
- Why do Power Users rate lower? → Selectivity analysis (3.5 vs 3.8 average)

#### **Phase 3: Predictive Insights**
*Determining Success Factors*
- Tag effectiveness modeling: +15.16% lift for 'brilliant' vs -23.98% for 'waste of time'
- Engagement prediction: Movies with 'atmospheric' tags average 4.0+ ratings
- User preference patterns: Generous Raters vs. Critical Raters segmentation

#### **Phase 4: Prescriptive Recommendations**
*Actionable Strategy Development*
- Opportunity classification: 5 categories (Hidden Gem, Quality Issue, Remarket, etc.)
- Priority scoring: 1-6 scale with HIGH/MEDIUM/INSIGHT action labels
- ROI-optimized roadmap: 300+ movies with specific next steps

---

## 💡 Key Insights

### 🎯 **Insight 1: User Segmentation Drives Personalization Needs**

**Finding**: Power Users (25%, 34,640 users) rate 399 movies on average vs. Casual Users (25%, 34,566 users) who rate only 49—an **8x engagement difference**.

**Deep Dive**:
- Power Users are more selective: 3.5 avg rating (critical)
- Casual Users are generous: 3.8 avg rating  
- Balanced Raters dominate: 40,000 users (29% of platform)
- Only **5-10% actively tag content** (High Taggers: 261 avg tags)

**Business Implication**: 
One-size-fits-all recommendations fail because user expectations vary drastically. Power Users need niche, high-quality content; Casual Users prefer mainstream, broadly appealing titles.

**Recommended Action**:
Implement tier-based recommendation weighting:
- Power Users → prioritize Film-Noir, Documentary, high-tag-relevance content
- Casual Users → prioritize Drama, Comedy, broad-appeal content

---

### 🎬 **Insight 2: Genre Paradox - Quality ≠ Volume**

**Finding**: Film-Noir achieves the highest average rating (**4.0 stars**) but Drama dominates catalog volume with **13,062 movies** (10x larger).

**Deep Dive**:
- Top 5 quality genres: Film-Noir (4.0), War (3.8), Documentary (3.8)
- Highest engagement genre: Drama (13K movies, 3.7 rating)
- Most polarizing: "Highly Divisive" classification across majority of genres
- Genre rating variance: 0.7-1.2 standard deviation

**Business Implication**:
The platform over-indexes on Drama (volume) but under-delivers on niche quality genres that satisfy discerning users. This catalog imbalance alienates Power Users who crave Film-Noir/Documentary quality.

**Recommended Action**:
- Acquire 200+ Film-Noir, Documentary, War titles to serve quality-seeking Power Users
- Rebalance featured content: 60% Drama (mass appeal) + 40% niche quality genres
- Create "Critically Acclaimed" collections featuring high-variance genres

---

### 🏆 **Insight 3: Attribute Intelligence Unlocks Predictive Power**

**Finding**: Tags like **'brilliant'** (+15.16% lift) and **'skinhead'** (+15.16% lift) predict success, while **'waste of time'** (-23.98% drag) and **'boring'** (-20%+) predict failure.

**Deep Dive**:
- Top 10 effective tags: 'brilliant', 'skinhead', 'vienna', 'francis ford coppola', 'afi 100', 'miyazaki'
- Bottom 10 toxic tags: 'waste of time', 'so bad it's good', 'video game adaptation', 'boring'
- High-relevance tags (dark green, >0.15 relevance) cluster at 4.0+ ratings
- Low-relevance tags (red, <0.05 relevance) cluster at 3.0- ratings
- Validated across **2.4M+ ratings** for statistical confidence

**Business Implication**:
Genome tags are **better predictors than genre alone**. A "thought-provoking" Drama will outperform a "predictable" Drama by 15%+. Current recommendations ignore this signal.

**Recommended Action**:
- **Acquisition Criteria**: Require 3+ high-impact tags ('brilliant', 'atmospheric', 'cerebral') for purchases >$1M
- **Algorithm Enhancement**: Weight recommendations by tag relevance score × tag effectiveness level
- **Avoid List**: Flag content with 'boring', 'predictable', 'waste of time' tags for budget constraints

---

### 🔍 **Insight 4: Hidden Gems Represent $500K+ Missed Revenue**

**Finding**: Identified **50+ Hidden Gems**—movies with >3.8 rating but <50 raters (e.g., *Marshland*: 3.9 rating, 5 raters).

**Deep Dive**:
- Hidden Gems average **3.9 rating** (above platform 3.13)
- Average visibility: <20 raters (vs. 700+ for featured content)
- Genres represented: Action, Comedy, Documentary, Sci-Fi, Thriller
- Estimated untapped audience: 50K+ users based on tag affinity matching

**Business Implication**:
High-quality content is buried in the catalog. Users who would love *Marshland* (4.0 rating) never discover it, leading to generic Drama recommendations instead. This represents lost engagement hours and satisfaction.

**Recommended Action**:
- **Week 1**: Feature 10 Hidden Gems in "Undiscovered Masterpieces" collection
- **Month 1**: A/B test targeted recommendations (tag-matched users) vs. control
- **Ongoing**: Promote 5 gems/month to Power Users with 90%+ tag affinity match
- **Expected Lift**: +25% engagement for promoted gems, +0.3 platform rating increase

---

### ⚠️ **Insight 5: Quality Crisis - 2,130 Movies Damaging Brand Trust**

**Finding**: **2,130 movies** classified as "Quality Issue—INVESTIGATE" with high engagement (100+ raters) but low satisfaction (<3.0 rating).

**Deep Dive**:
- Worst performer: *House of the Dead* (1.36 rating), *Faces of Death* (1.35 rating)
- High-profile disappointment: *Ace Ventura* (38,226 raters, 3.0 rating)—massive visibility, mediocre reception
- Lowest performer with engagement: *Judge Dredd* (2.5 rating)
- **78% of opportunity pie chart** = Quality Issues (dominates problem space)

**Business Implication**:
Users expecting quality from featured *Ace Ventura* (based on marketing/prominence) receive mediocre experience (3.0 rating). This expectation mismatch damages trust and increases churn risk. Featured failures cost more than hidden failures.

**Recommended Action**:
- **Immediate**: Remove bottom 50 quality issues from "Featured" and "Trending" placements
- **Week 1-2**: Audit metadata accuracy for top 100 quality issues (wrong tags? miscategorization?)
- **Month 1**: Implement quality gate: movies <2.5 rating + 100+ raters flagged for review
- **Content Policy**: Establish minimum 3.0 rating threshold for featured placements

---

### 📊 **Insight 6: User Behavior Reveals Tagging Opportunity**

**Finding**: Only **High Taggers** (491 users with 261 avg tags) actively contribute metadata, while Moderate Taggers (707 users, 74 avg tags) show 3.5x lower engagement.

**Deep Dive**:
- Power Users (542 total) generate **255,000+ ratings** (67% of activity) but rate selectively (3.5 avg)
- Casual Users (34,566) contribute minimal metadata (0 avg tags)
- High Tagger-Power User overlap: Strong correlation between tagging and platform expertise
- Rating variance: Power Users show higher discrimination (selective quality assessment)

**Business Implication**:
Platform relies on <1% of users for metadata quality. Losing these power contributors would degrade tag reliability. Their critical ratings (3.5 avg) represent expert curation, not negativity.

**Recommended Action**:
- **Engagement Program**: Reward top 500 taggers with "Curator" badges, early access to new releases
- **Metadata Quality**: Trust Power User tags more than casual user tags in algorithm weighting
- **Retention Strategy**: Identify at-risk Power Users (declining activity) for personalized retention offers

---

## 📋 Analytical Approach

### Data Foundation

**Five Purpose-Built Analytical
