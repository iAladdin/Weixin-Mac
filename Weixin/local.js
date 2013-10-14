var testVar = 'New JS loaded!';

console.log(testVar);

function newFun(dynParam)
{
    console.log('You just passed '+dynParam+ ' as parameter.');
}

function replaceImgEvent{
    var img = $('.cloudImg img')[0];
    img.removeAttribute('click');
    img.addEventListener('click',function(event){localScript.getImageUrlWithCookie(img.attributes['rawsrc'].value,document.cookie)})
}