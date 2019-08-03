--Meklord Army Astronomikle
function c50494244.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50494244,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c50494244.sptg)
	e1:SetOperation(c50494244.spop)
	c:RegisterEffect(e1)
	--Destroy Himself
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c50494244.pentg)
	e2:SetOperation(c50494244.penop)
	c:RegisterEffect(e2)
	--Set Trap
	local e3=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50494244,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,50494244+1)
	e3:SetTarget(c50494244.settg)
	e3:SetOperation(c50494244.setop)
	c:RegisterEffect(e3)
end

function c50494244.spfilter2(c,e,tp)
	return c:IsSetCard(24595) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(50494244)
end
function c50494244.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c50494244.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c50494244.spop(e,tp,eg,ep,ev,re,r,rp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local g=Duel.GetMatchingGroup(c50494244.spfilter2,tp,LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsAttribute,nil,sg1:GetFirst():GetAttribute())
		if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(50494244,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			end
			Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c50494244.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c50494244.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end

function c50494244.penfilter(c,e,tp)
	return c:IsSetCard(24595) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(50494244)
end
function c50494244.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c50494244.penfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c50494244.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c50494244.penfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c50494244.sfilter(c)
	return c:IsCode(4081825) or c:IsCode(41475424) or c:IsCode(77864539) or c:IsCode(95007306) or c:IsCode(63485578) 
	  or c:IsCode(12986778) or c:IsCode(50449979) or c:IsCode(85775486) or c:IsCode(60682160) or c:IsCode(59371387)
	  or c:IsCode(61561967) or c:IsCode(67328336) or c:IsCode(86997073) or c:IsCode(11681434) or c:IsCode(4803054)
	  or c:IsCode(32552314)
	  and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function c50494244.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c50494244.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c50494244.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c50494244.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
		
