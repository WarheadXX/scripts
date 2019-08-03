--サイバネット・コーデック
--Cynet Codec
--Scripted by Eerie Code
function c60018643.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c60018643.thtg)
	e2:SetOperation(c60018643.thop)
	c:RegisterEffect(e2)
	--register attributes
	if not c60018643.global_flag then
		c60018643.global_flag=true
		c60018643.attr_list={}
		c60018643.attr_list[0]=0
		c60018643.attr_list[1]=0
		cynetCodecAttributes = {}
		cynetCodecDark = 0
		cynetCodecLight = 0
		cynetCodecEarth = 0
		cynetCodecFire = 0
		cynetCodecWater = 0
		cynetCodecWind = 0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCountLimit(1)
		ge1:SetCondition(c60018643.resetop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60018643.resetop(e,tp,eg,ep,ev,re,r,rp)
	c60018643.attr_list[0]=0
	c60018643.attr_list[1]=0
	cynetCodecDark = 0
	cynetCodecLight = 0
	cynetCodecEarth = 0
	cynetCodecFire = 0
	cynetCodecWater = 0
	cynetCodecWind = 0
	return false
end
function c60018643.newfilter()
 if cynetCodecDark == 1 then return false end
 if cynetCodecLight == 1 then return false end
 if cynetCodecEarth == 1 then return false end
 if cynetCodecFire == 1 then return false end
 if cynetCodecWater == 1 then return false end
 if cynetCodecWind == 1 then return false end
 return true
end
function c60018643.thcfilter(c,e,tp)
	local attr=c:GetAttribute()
	local check = 0
    if(c:IsAttribute(ATTRIBUTE_DARK) and (cynetCodecDark == 1)) then check = 1 end
	if(c:IsAttribute(ATTRIBUTE_LIGHT) and (cynetCodecLight == 1)) then check = 1 end
	if(c:IsAttribute(ATTRIBUTE_EARTH) and (cynetCodecEarth == 1)) then check = 1 end
	if(c:IsAttribute(ATTRIBUTE_FIRE) and (cynetCodecFire == 1)) then check = 1 end
	if(c:IsAttribute(ATTRIBUTE_WATER) and (cynetCodecWater == 1)) then check = 1 end
	if(c:IsAttribute(ATTRIBUTE_WIND) and (cynetCodecWind == 1)) then check = 1 end
	return c:IsSetCard(0x101) and c:IsControler(tp) 
		and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_EXTRA)
		and c60018643.attr_list[tp] and (check == 0)
		-- and attr==0
		and c:IsCanBeEffectTarget(e)		
		and Duel.IsExistingMatchingCard(c60018643.thfilter,tp,LOCATION_DECK,0,1,nil,attr)
end
function c60018643.thfilter(c,attr)
	return c:IsRace(RACE_CYBERSE) and c:IsAttribute(attr) and c:IsAbleToHand()
end
function c60018643.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c60018643.thcfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c60018643.thcfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=eg:FilterSelect(tp,c60018643.thcfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60018643.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c60018643.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			c60018643.attr_list[tp]=c60018643.attr_list[tp] or tc:GetAttribute()
			if tc:IsAttribute(ATTRIBUTE_DARK) then cynetCodecDark = 1 end
			if tc:IsAttribute(ATTRIBUTE_LIGHT) then cynetCodecLight = 1 end
			if tc:IsAttribute(ATTRIBUTE_EARTH) then cynetCodecEarth = 1 end
			if tc:IsAttribute(ATTRIBUTE_FIRE) then cynetCodecFire = 1 end
			if tc:IsAttribute(ATTRIBUTE_WATER) then cynetCodecWater = 1 end
			if tc:IsAttribute(ATTRIBUTE_WIND) then cynetCodecWind = 1 end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60018643.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60018643.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_CYBERSE) and c:IsLocation(LOCATION_EXTRA)
end

