

function *g(limit:number) {
    for (var i = 0; i < limit; i++) {
        yield `i=${i}`;
    }
}

for (let i of g(100)) {
    console.log(i);
}

console.log("hi")

function delay(milliseconds: number) {
    return new Promise<void>(resolve => {
      setTimeout(resolve, milliseconds);
    });
}

async function dramaticWelcome() {
    console.log("Hello");

    for (let i = 0; i < 3; i++) {
        await delay(500);
        console.log(".");
    }

    console.log("World!");
}