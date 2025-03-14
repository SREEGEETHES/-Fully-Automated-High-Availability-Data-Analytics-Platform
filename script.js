import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
    vus: 10, // Number of virtual users
    duration: '30s', // Test duration
};

export default function () {
    let res = http.get('http://af146bc9db9ec4a8492c4753a55f603f-1542817203.ap-south-1.elb.amazonaws.com');

    check(res, {
        'status was 200': (r) => r.status == 200,
        'response time < 500ms': (r) => r.timings.duration < 500,
    });

    sleep(1); // Pause between requests
}
