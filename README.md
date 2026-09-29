Edge Detector

Let's learn it properly first, then I'll quiz you.

## 1. What is an edge?

A signal can change:

```text
                       ──────── 1
                        │
        0 ────────────      
```

That `0 → 1` transition is a **rising edge**.

Similarly:

```text
1 ────────────┐
              │
              └──────── 0
```

is a **falling edge**.

An edge detector produces a short pulse when such a transition occurs.

---

# 2. Rising-edge detector

Suppose input is:

```text
x:

0 0 0 0 1 1 1 1
        ↑
     rising edge
```

We want:

```text
pulse:

0 0 0 0 1 0 0 0
        ↑
```

So the output should be `1` for approximately **one clock cycle** when `x` changes from `0 → 1`.

---

# 3. The key idea: remember the previous value

Hardware needs to know:

> "What was `x` during the previous clock cycle?"

So we store the previous value using a flip-flop.

Let:

```text
x_d = delayed/previous value of x
```

At every positive clock edge:

```verilog id="m1f5ce"
x_d <= x;
```

Now we have:

```text
current x
previous x_d
```

For a rising edge:

```text
current x = 1
previous x_d = 0
```

Therefore:

```text
edge = x & ~x_d
```

---

# 4. Verilog implementation

```verilog id="j6slp8"
module rising_edge_detector (
    input  clk,
    input x,
    output reg edge
);

reg x_d;

always @(posedge clk) begin
    x_d <= x;
end

assign edge = x & ~x_d;

endmodule
```

The important equation is:

```verilog id="i9u9e4"
edge = x & ~x_d;
```

---

# 5. Why does this work?

Let's make a table.

| Previous `x_d` | Current `x` | `~x_d` |   `edge = x & ~x_d` |
| -------------: | ----------: | -----: | ------------------: |
|              0 |           0 |      1 |               **0** |
|              0 |           1 |      1 | **1** ← rising edge |
|              1 |           0 |      0 |               **0** |
|              1 |           1 |      0 |               **0** |

Only this combination:

```text
previous = 0
current  = 1
```

produces `1`.

Therefore:

> `x & ~x_d` detects a **0 → 1 transition**.

---

# 6. Falling-edge detector

For falling edge we want:

```text
previous = 1
current  = 0
```

So:

```verilog id="gyq8l4"
edge = ~x & x_d;
```

Truth table:

| Previous `x_d` | Current `x` |               Output |
| -------------: | ----------: | -------------------: |
|              0 |           0 |                    0 |
|              0 |           1 |                    0 |
|              1 |           0 | **1** ← falling edge |
|              1 |           1 |                    0 |

---

# 7. Both-edge detector

If you want a pulse for **either** transition:

```text
0 → 1
or
1 → 0
```

then:

```verilog id="br7zwr"
edge = x ^ x_d;
```

Why XOR?

| `x_d` | `x` |   XOR |
| ----: | --: | ----: |
|     0 |   0 |     0 |
|     0 |   1 | **1** |
|     1 |   0 | **1** |
|     1 |   1 |     0 |

So XOR detects **any change**.

---

# 8. Hardware picture

For a rising-edge detector:

```text
                    ┌─────────┐
              ┌────►│ D       │
              │     │   FF    │
              │     └────┬────┘
              │          │
              │         x_d
              │          │
              │          ▼
x ────────────┼───────── AND ─────► edge
              │           ▲
              │           │
              │         NOT
              │           ▲
              └───────────┘
```

The flip-flop remembers the previous input, and the combinational logic compares the current and previous values.

---



An edge detector **needs memory**.



> "Can you detect a rising edge using only combinational logic?"

The basic answer is:

**No, not a clock-to-clock edge detector**, because you need to compare the current input with its previous value. The previous value requires storage, such as a flip-flop.

---



Suppose:

```text
x = 0
```

Initially, and then on successive positive clock edges `x` is:

```text
Clock:  1   2   3   4   5
x:      0   0   1   1   0
```

For a **rising-edge detector**:

```verilog
edge = x & ~x_d;
```

What will `edge` be after each clock?

**A)** `0 0 1 0 0`
**B)** `0 1 1 0 1`
**C)** `0 0 0 1 0`
**D)** `1 0 1 0 0`

ans A
