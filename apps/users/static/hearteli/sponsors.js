(() => {
  const csrf=document.querySelector('[name=csrfmiddlewaretoken]')?.value;
  async function event(id,kind){
    const r=await fetch('/api/users/sponsor-events/',{method:'POST',keepalive:true,headers:{'Content-Type':'application/json','X-CSRFToken':csrf},body:JSON.stringify({event_id:id,event_type:kind,visible_fraction:.5,visible_ms:1000})});
    if(!r.ok)throw Error('Sponsor no longer available');return r.json();
  }
  document.querySelectorAll('[data-sponsored-ticket]').forEach(card=>{
    let timer=null,shown=false,visible=false;
    const arm=()=>{clearTimeout(timer);if(visible&&!shown&&!document.hidden)timer=setTimeout(async()=>{try{await event(card.dataset.sponsoredTicket,'impression');shown=true;}catch{}},1000);};
    if(!('IntersectionObserver' in window))return;
    const observer=new IntersectionObserver(entries=>entries.forEach(entry=>{visible=entry.intersectionRatio>=.5;arm();}),{threshold:[0,.5,1]});observer.observe(card);
    document.addEventListener('visibilitychange',arm);
    card.querySelectorAll('[data-sponsored-click]').forEach(link=>link.addEventListener('click',async e=>{
      e.preventDefault();
      if(shown)try{await event(card.dataset.sponsoredTicket,'click');}catch{}
      // Profile navigation remains available if a paid campaign expires.
      window.location.assign(link.href);
    }));
  });
  document.querySelectorAll('[data-sponsored-booking]').forEach(form=>{
    if(form.dataset.sponsoredBooking)form.addEventListener('focusin',()=>event(form.dataset.sponsoredBooking,'booking_start').catch(()=>{}),{once:true});
  });
})();
