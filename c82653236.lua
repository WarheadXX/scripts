--De-Xyz
function c82653236.initial_effect(c)	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c82653236.target)
	e1:SetOperation(c82653236.activate)
	c:RegisterEffect(e1)
	--Detach All
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c82653236.dtcost)
	e2:SetTarget(c82653236.dttarget)
	e2:SetOperation(c82653236.dtactivate)
	c:RegisterEffect(e2)
end
function c82653236.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAbleToExtra()
end
function c82653236.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c82653236.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c82653236.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c82653236.spfilter(c,e,tp)
	return not c:IsControler(tp) or c:IsLocation(LOCATION_GRAVE)
		and (c:GetReasonCard()~=xyzc and c:GetPreviousLocation(LOCATION_OVERLAY) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82653236.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c82653236.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler(tp))
	local mg=tc:GetFirst():GetOverlayGroup()
	Duel.SendtoGrave(mg,REASON_EFFECT)
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 then
		local g=mg:Filter(c82653236.spfilter,nil,e,tp)
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ft<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=g:Select(tp,ft,ft,nil)
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				Duel.SpecialSummonComplete()
		end
	end
	
function c82653236.dtfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c82653236.dtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c82653236.dttarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsLocation(LOCATION_MZONE) and c82653236.dtfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c82653236.dtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_DETACH)
	Duel.SetChainLimit(aux.FALSE)
end
function c82653236.dtactivate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c82653236.dtfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler(tp))
	Duel.SetOperationInfo(0,CATEGORY_DETACH,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
	local mg=g:GetFirst():GetOverlayGroup()
	ct=Duel.SendtoGrave(mg,REASON_EFFECT)
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end

