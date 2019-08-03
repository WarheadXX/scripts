--Gravekeeper's Cleric
function c60222823.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60222823.spcon)
	c:RegisterEffect(e1)
	--Add "Necrovalley" based card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60222823,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c60222823.thcon)
	e2:SetTarget(c60222823.thtg)
	e2:SetOperation(c60222823.thop)
	c:RegisterEffect(e2)
	--Get Gravekeeper
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,60222823)
	e3:SetTarget(c60222823.sptg)
	e3:SetOperation(c60222823.spop)
	c:RegisterEffect(e3)
end

function c60222823.cfilter(c)
	return c:IsCode(47355498)
end
function c60222823.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c60222823.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and
	Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c60222823.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c60222823.filter(c)
	return c:IsSetCard(145) or c:IsCode(99523325) or c:IsCode(30450531) or c:IsCode(72405967) 
	or c:IsCode(21157847) or c:IsCode(73821767) and c:IsAbleToHand()
end
function c60222823.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60222823.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60222823.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60222823.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c60222823.spfilter(c,e,tp)
	return c:IsSetCard(46) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsLevelBelow(4)
end
function c60222823.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60222823.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60222823.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60222823.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENCE)
	end
end