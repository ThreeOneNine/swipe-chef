import Swiper from 'swiper';

const swiperTest = new Swiper('.swiper-container', {
      cssMode: true,
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
      pagination: {
        el: '.swiper-pagination'
      },
      mousewheel: true,
      keyboard: true,
    });

console.log("hello from sssswiper")

export { swiperTest };
